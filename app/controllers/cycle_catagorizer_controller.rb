root = '../..'

require_relative root + '/config/environment.rb'
require_relative root + '/lib/Docker'
require_relative root + '/lib/DockerTestRunner'
require_relative root + '/lib/DummyTestRunner'
require_relative root + '/lib/Folders'
require_relative root + '/lib/Git'
require_relative root + '/lib/HostTestRunner'
require_relative root + '/lib/OsDisk'


class CycleCatagorizerController < ApplicationController
  def cycle_catgories
    @cycles = Cycle.all
  end

  def parseCSV
    @filename = '/Users/michaelhilton/Development/Research/TDDStudy/corpus.csv'
    @CSVRows = SmarterCSV.process(@filename ,{:col_sep => "\|",  :force_simple_split => true })

    # puts @CSVRows

    puts @CSVRows[1]

    @CSVRows.each do |row|
      kata = Kata.new do |k|
        k.cyberdojo_id = row[:kataid]
      end
    end

    #user = User.create(name: "David", occupation: "Code Artist")
  end

  def listCC
    @allSessions = Session.all
  end


  def ListKatasInDojo
    @allSessions = Session.all

  end

  def ListAllCompiles
    puts "####################DEBUG"
    puts Phase.all
    @allPhases = Phase.all
  end

  def InsertTestCompiles
    compile = Compile.new do |c|
      c.light_color = "COLOR"
    end
    compile.save
  end

  def root_path
    Rails.root.to_s + '/'
  end

  def dojo
    externals = {
      :disk   => OsDisk.new,
      :git    => Git.new,
      :runner => DummyTestRunner.new
    }
    Dojo.new(root_path,externals)
  end

  #0704A92264
  #elephant

  def ImportAllKatas
    @katas = dojo.katas
    Session.delete_all
    Compile.delete_all

    i = 0
    @katas.each do |kata|
      puts kata
      if(kata.language.name == "Java-1.8_JUnit")
        i+= 1
        kata.avatars.active.each do |avatar|
          session = Session.new do |s|
            s.cyberdojo_id = kata.id
            s.avatar = avatar.name
          end
          session.save

          s = Session.find_by(cyberdojo_id: kata.id, avatar: avatar.name)
          @redlights = 0
          @greenlights = 0
          @amberlights = 0
          @path = avatar.path
          @sloc = 0
          @test_loc = 0
          @production_loc = 0
          @language = kata.language.name
          @runtests = 0
          @runtestfails = 0
          s.kata_name = kata.exercise.name
          # s.cyberdojo_id = kata.id
          s.language_framework = kata.language.name
          s.path = kata.path
          # s.avatar = avatar.name
          s.start_date = kata.created
          s.total_light_count = avatar.lights.count
          s.final_light_color = avatar.lights[avatar.lights.count-1].colour
          maxRedString = 1
          currRedString = 1
          lastLightColor = "none"
          avatar.lights.each do |curr_light|
            #Count Types of Lights
            case curr_light.colour.to_s
            when "red"
              @redlights += 1
              if(lastLightColor == "red")
                currRedString += 1
                if(currRedString > maxRedString)
                  maxRedString = currRedString
                end
              else
                lastLightColor = "red"
              end
            when "green"
              @greenlights += 1
              lastLightColor = "green"
              currRedString = 1
            when "amber"
              @amberlights += 1
              lastLightColor = "amber"
              currRedString = 1
            end

            puts "*********************DEBUG*********************"
            #puts curr_light.tag.diff(0)
            puts curr_light.tag.visible_files.first
            @compile = s.compiles.create(light_color: curr_light.colour.to_s, git_tag: curr_light.number.to_s)
          end
          s.red_light_count = @redlights
          s.green_light_count = @greenlights
          s.amber_light_count = @amberlights
          s.max_consecutive_red_chain_length = maxRedString
          calc_sloc
          s.total_sloc_count = @sloc
          s.production_sloc_count = @production_loc
          s.test_sloc_count = @test_loc

          s.cumulative_test_run_count = @runtests
          s.cumulative_test_fail_count = @runtestfails
          #DO YOUR THiNG
          #s.final_number_tests = XX

          s.save

          #@compile = session.compiles.create(light_color: 'NO_COLOR')
        end
      end
      if(i > 40)
        break
      end
    end
  end

  def buildCycleData
    Cycle.delete_all
    @allCycles = []

    @TIME_CEILING = 1200 # Time Ceiling in Seconds Per Light
    @supp_test_langs = ["Java-1.8_JUnit", "Java-1.8_Mockito", "Java-1.8_Approval", "Java-1.8_Powermockito", "Python-unittest", "Python-pytest", "Ruby-TestUnit", "Ruby-Rspec", "C++-assert", "C++-GoogleTest", "C++-CppUTest", "C++-Catch", "C-assert", "Go-testing", "Javascript-assert", "C#-NUnit", "PHP-PHPUnit", "Perl-TestSimple", "CoffeeScript-jasmine", "Erlang-eunit", "Haskell-hunit", "Scala-scalatest", "Clojure-.test", "Groovy-JUnit", "Groovy-Spock"]
    @supp_fail_langs = ["Java-1.8_JUnit"]

    i = 0
    @katas = dojo.katas
    @katas.each do |kata|
      if(kata.language.name == "Java-1.8_JUnit")
        i+= 1
        kata.avatars.active.each do |avatar|
          @json_cycles =  ""
          @start_date = kata.created
          @total_time = 0
          @redlights = 0
          @greenlights = 0
          @amberlights = 0
          @consecutive_reds = 0
          @avatar = avatar
          @kata = kata
          @transitions = ""
          @cycles = 0
          @edited_lines = 0
          calc_cycles

          @allCycles.push(@json_cycles)
        end
        if(i > 40)
          break
        end
      end
    end
  end



  def calc_cycles
    pos = 0
    prev_outer = nil
    prev_cycle_end = nil
    test_change = false
    prod_change = false
    in_cycle = false
    cycle = ""
    cycle_lights = Array.new
    cycle_test_edits = 0
    cycle_code_edits = 0
    cycle_total_edits = 0
    cycle_test_change = 0
    cycle_code_change = 0
    cycle_reds = 0
    cycle_time = 0
    first_cycle = true

    #Start Json Array
    @json_cycles += '['

    curr_session = Session.where(cyberdojo_id: @kata.id, avatar: @avatar.name)
    curr_cycle = Cycle.new(cycle_position: pos)

    @avatar.lights.each_with_index do |curr, index|

      #Push light to queue
      cycle_lights.push(curr)

      #Aquire file changes from light
      if prev_outer.nil?
        diff = @avatar.tags[0].diff(curr.number)
        test_change = true
      else
        diff = @avatar.tags[prev_outer.number].diff(curr.number)
      end

      #Check for changes to Test or Prod code
      diff.each do |filename,content|
        non_code_filenames = [ 'output', 'cyber-dojo.sh', 'instructions' ]
        unless non_code_filenames.include?(filename)
          if content.count { |line| line[:type] === :added } > 0 || content.count { |line| line[:type] === :deleted } > 0
            #Check if file is a Test
            if (filename.include?"Test") || (filename.include?"test") || (filename.include?"Spec") || (filename.include?"spec") || (filename.include?".t") || (filename.include?"Step") || (filename.include?"step")
              test_change = true
            else
              prod_change = true
            end
          end
        end
      end #End of Diff For Each

      #Green indicates end of cycle, also process if at last light
      if curr.colour.to_s == "green" || index == @avatar.lights.count - 1

        #Determine the type of cycle
        if (test_change && !prod_change) || (!test_change && prod_change) || (!test_change && !prod_change)
          cycle = "R" #Refactor if changes are exclusive to production or test files
        else
          if in_cycle == true && curr.colour.to_s == "green"
            cycle = "TP" #Test-Prod
          else
            cycle = "R"
          end
        end

        #Begin Json Cycle Light Data
        if cycle == "TP"
          if first_cycle == true
            @json_cycles += '{"lights":['
            first_cycle = false
          else
            @json_cycles += ',{"lights":['
          end
        end

        prev = nil
        #Process Metrics & Output Data
        cycle_lights.each_with_index do |light, light_index|

          #Count Lines Modified in Light, Cycle & Kata
          #Lines Modified in Light
          if prev.nil? #If no previous light in this cycle use the last cycle's end
            test_edits, code_edits = calc_lines(prev_cycle_end, light)
          else
            test_edits, code_edits = calc_lines(prev, light)
          end
          #Total Lines Modified in Cycle
          cycle_test_edits += test_edits
          cycle_code_edits += code_edits
          #Total Lines Modified in Kata
          @edited_lines += test_edits
          @edited_lines += code_edits
          light_edits = code_edits + test_edits
          cycle_total_edits += light_edits

          #Determine Time Spent in Light
          if prev_cycle_end.nil? && prev.nil? #If the first light of the Kata
            time_diff = light.time - @start_date
          else
            if prev.nil? #If the first light of the Cycle
              time_diff = light.time - prev_cycle_end.time
            else
              time_diff = light.time - prev.time
            end
          end

          #Drop Time if it hits the Time Ceiling
          if time_diff > @TIME_CEILING
            time_diff = 0
          end

          #Increment Time
          @total_time += time_diff
          cycle_time += time_diff

          #Count Types of Lights
          case light.colour.to_s
          when "red"
            @redlights += 1
            cycle_reds += 1
          when "green"
            @greenlights += 1
          when "amber"
            @amberlights += 1
          end

          #Count Failed Tests
          if prev.nil? #If no previous light in this cycle use the last cycle's end
            count_fails(prev_cycle_end, light)
          else
            count_fails(prev, light)
          end

          #Eliminate Unsupported Stats
          unless @supp_test_langs.include?@language
            light_edits = "NA"
            test_edits = "NA"
            code_edits = "NA"
          end

          #Output
          if (cycle == "TP")
            if light_index == 0
              @json_cycles += '{"color":"'
            else
              @json_cycles += ',{"color":"'
            end
            @json_cycles += light.colour.to_s + '","totalEdits":' + light_edits.to_s + ',"testEdits":' + test_edits.to_s + ',"codeEdits":' + code_edits.to_s + ',"time":' + time_diff.to_s + '}'
            @transitions += "+" + "{" + light.colour.to_s + ":" + light_edits.to_s + ":" + test_edits.to_s + ":" + code_edits.to_s + ":" + time_diff.to_s + "}"
          elsif cycle == "R"
            @transitions += "~" + "{" + light.colour.to_s + ":" + light_edits.to_s + ":" + test_edits.to_s + ":" + code_edits.to_s + ":" + time_diff.to_s + "}"
          end

          #Assign current light to previous
          prev = light
        end #End of For Each

        #Eliminate Unsupported Stats
        unless @supp_test_langs.include?@language
          cycle_total_edits = "NA"
          cycle_test_edits = "NA"
          cycle_code_edits = "NA"
          cycle_test_change = "NA"
          cycle_code_change = "NA"
        end

        #If this was a TP Cycle then process it accordingly
        if cycle == "TP"
          #Set consecutive reds if new maximum
          if cycle_reds > @consecutive_reds
            @consecutive_reds = cycle_reds
          end
          #Count changes to Test and Code from diff of entire cycle
          cycle_test_change, cycle_code_change = calc_lines(prev_cycle_end, curr)
          #Output Json Cycle Summary
          @json_cycles += '],"totalCycleEdits":' + cycle_total_edits.to_s + ',"totalCycleTestEdits":' + cycle_test_edits.to_s + ',"totalCycleCodeEdits":' + cycle_code_edits.to_s + ',"cycleTestChanges":' + cycle_test_change.to_s + ',"cycleCodeChanges":' + cycle_code_change.to_s + ',"totalCycleTime":' + cycle_time.to_s + '}'
          #Increment Cycle Counter
          @cycles += 1
          curr_cycle.valid_tdd = true
          #elsif cycle == "R"
        else
          curr_cycle.valid_tdd = false
        end


        curr_cycle.session_id = curr_session[0].id
        curr_cycle.save

        #Reset Cycle Metrics
        test_change = false
        prod_change = false
        in_cycle = false
        cycle_test_change = 0
        cycle_code_change = 0
        cycle_test_edits = 0
        cycle_code_edits = 0
        cycle_total_edits = 0
        cycle_time = 0
        cycle_reds = 0
        cycle_lights.clear

        pos += 1
        prev_cycle_end = curr

        curr_cycle = Cycle.new(cycle_position: pos)

      elsif curr.colour.to_s == "red"
        in_cycle = true
      end #End of "If Green"

      prev_outer = curr

    end #End of For Each

    #End Json Array
    @json_cycles += ']'

    #Determine if Kata Ends on Green
    if @avatar.lights[@avatar.lights.count - 1].colour.to_s == "green"
      @ends_green = 1
    else
      @ends_green = 0
    end

  end

  def count_fails(prev, curr)

    #Take Diff
    if prev.nil? #If no previous light use the beginning
      diff = @avatar.tags[0].diff(curr.number)
    else
      diff = @avatar.tags[prev.number].diff(curr.number)
    end

    diff.each do |filename, content|
      if filename.include?"output"
        content.each do |line|

          case @language.to_s
          when "Java-1.8_JUnit"
            re = /\{:type=>:(added|same), :line=>\"Tests run: (?<tests>\d+),  Failures: (?<fails>\d+)\", :number=>\d+\}/
            result = re.match(line.to_s)

            unless result.nil?
              @runtests += result['tests'].to_i
              @runtestfails += result['fails'].to_i
            end
          end
        end
      end
    end

  end


  def calc_lines(prev, curr)
    # determine number of lines changed between lights
    test_count = 0
    code_count = 0
    is_test = false

    if prev.nil? #If no previous light use the beginning
      diff = @avatar.tags[0].diff(curr.number)
    else
      diff = @avatar.tags[prev.number].diff(curr.number)
    end

    diff.each do |filename,lines|

      isFile = filename.match(/\.java$|\.py$|\.c$|\.cpp$|\.js$|\.php$|\.rb$|\.hs$|\.clj$|\.go$|\.scala$|\.coffee$|\.cs$|\.groovy$\.erl$/i)

      unless isFile.nil? || deleted_file(lines) || new_file(lines)
        lines.each do |line|
          begin
            case @language.to_s
            when "Java-1.8_JUnit"
              is_test = true if /junit/.match(line.to_s)
            when "Java-1.8_Mockito"
              is_test = true if /org\.mockito/.match(line.to_s)
            when "Java-1.8_Powermockito"
              is_test = true if /org\.powermock/.match(line.to_s)
            when "Java-1.8_Approval"
              is_test = true if /org\.approvaltests/.match(line.to_s)
            when "Python-unittest"
              is_test = true if /unittest/.match(line.to_s)
            when "Python-pytest"
              is_test = true if filename.include?"test"
            when "Ruby-TestUnit"
              is_test = true if /test\/unit/.match(line.to_s)
            when "Ruby-Rspec"
              is_test = true if /describe/.match(line.to_s)
            when "C++-assert"
              is_test = true if /cassert/.match(line.to_s)
            when "C++-GoogleTest"
              is_test = true if /gtest\.h/.match(line.to_s)
            when "C++-CppUTest"
              is_test = true if /CppUTest/.match(line.to_s)
            when "C++-Catch"
              is_test = true if /catch\.hpp/.match(line.to_s)
            when "C-assert"
              is_test = true if /assert\.h/.match(line.to_s)
            when "Go-testing"
              is_test = true if /testing/.match(line.to_s)
            when "Javascript-assert"
              is_test = true if /assert/.match(line.to_s)
            when "C#-NUnit"
              is_test = true if /NUnit\.Framework/.match(line.to_s)
            when "PHP-PHPUnit"
              is_test = true if /PHPUnit_Framework_TestCase/.match(line.to_s)
            when "Perl-TestSimple"
              is_test = true if /use Test/.match(line.to_s)
            when "CoffeeScript-jasmine"
              is_test = true if /jasmine-node/.match(line.to_s)
            when "Erlang-eunit"
              is_test = true if /eunit\.hrl/.match(line.to_s)
            when "Haskell-hunit"
              is_test = true if /Test\.HUnit/.match(line.to_s)
            when "Scala-scalatest"
              is_test = true if /org\.scalatest/.match(line.to_s)
            when "Clojure-.test"
              is_test = true if /clojure\.test/.match(line.to_s)
            when "Groovy-JUnit"
              is_test = true if /org\.junit/.match(line.to_s)
            when "Groovy-Spock"
              is_test = true if /spock\.lang/.match(line.to_s)
            else
              #Language not supported
            end
          rescue
            puts "Error: Reading in calc_lines"
          end

          break if is_test == true
        end #End of Lines For Each

        #POSSIBLE TODO: Add bag to check for double counting of edited lines
        if is_test
          test_count += lines.count { |line| line[:type] === :added }
          test_count += lines.count { |line| line[:type] === :deleted }
        else
          code_count += lines.count { |line| line[:type] === :added }
          code_count += lines.count { |line| line[:type] === :deleted }
        end

        is_test = false
      end #End of Unless statment
    end #End of Diff For Each

    return test_count, code_count
  end

  def deleted_file(lines)
    return lines.all? { |line| line[:type] === :deleted }
  end

  def new_file(lines)
    return lines.all? { |line| line[:type] === :added }
  end

  def calc_sloc
    puts "CALC SLOC"
    dataset = {}
    Dir.entries(@path.to_s + "sandbox").each do |currFile|
      isFile = currFile.to_s =~ /\.java$|\.py$|\.c$|\.cpp$|\.js$|\.php$|\.rb$|\.hs$|\.clj$|\.go$|\.scala$|\.coffee$|\.cs$|\.groovy$\.erl$/i
      puts "isFile"
      puts isFile
      unless isFile.nil?
        file = @path.to_s + "sandbox/" + currFile.to_s
        command = `./cloc-1.62.pl --by-file --quiet --sum-one --exclude-list-file=./clocignore --csv #{file}`
        puts "./cloc-1.62.pl --by-file --quiet --sum-one --exclude-list-file=./clocignore --csv #{file}"
        puts `pwd`
        puts command
        csv = CSV.parse(command)
        puts csv.to_s
        unless(csv.inspect() == "[]")
          if @language.to_s == "Java-1.8_JUnit"
            begin
              if File.open(file).read.scan(/junit/).count > 0
                @test_loc = @test_loc + csv[2][4].to_i
                puts "TEST SLOC"
                puts @test_loc
              else
                @production_loc = @production_loc + csv[2][4].to_i
                puts "PRODUCTION SLOC"
                puts @production_loc
              end
            rescue
              puts "Error: Reading in calc_sloc"
            end
          end
          @sloc = @sloc + csv[2][4].to_i
        end
      end
    end
  end

  private :new_file, :deleted_file, :calc_lines

end
