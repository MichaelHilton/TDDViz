
# This data can be loaded with the rake db:seed (or created alongside the db with db:setup).
root = '../..'

require_relative root + '/config/environment.rb'
require_relative root + '/lib/Docker'
require_relative root + '/lib/DockerTestRunner'
require_relative root + '/lib/DummyTestRunner'
require_relative root + '/lib/Folders'
require_relative root + '/lib/Git'
require_relative root + '/lib/HostTestRunner'
require_relative root + '/lib/OsDisk'
#require_relative root + '/app/lib/ASTInterface'

#include ASTInterface

DEBUG = true
@TIME_CEILING = 1200 # Time Ceiling in Seconds Per Light

def root_path
  Rails.root.to_s + '/'
end

def number(value,width)
  spaces = ' ' * (width - value.to_s.length)
  "#{spaces}#{value.to_s}"
end

def dots(dot_count)
  dots = '.' * (dot_count % 32)
  spaces = ' ' * (32 - dot_count % 32)
  dots + spaces + number(dot_count,5)
end

def dojo
  externals = {
    :disk   => OsDisk.new,
    :git    => Git.new,
    :runner => DummyTestRunner.new
  }
  Dojo.new(root_path,externals)
end



def build_metric_data
  puts "build_metric_data " if DEBUG

  i = 0
  Session.all.each do |session|
    print session.cyberdojo_id.to_s+ " " if DEBUG
    print session.language_framework.to_s+ " " if DEBUG
	i+= 1
	#      print "Number ACTIVE avatars:"
	#      puts  kata.avatars.active.count
	#      puts  kata.id
	print session.avatar.to_s+ " " if DEBUG

    #Calculate Metric Data
    calc_metrics(session)

  end
end

def calc_metrics(session)


	session.compiles.each_with_index do |curr, index|

    curr.test_change = false
    curr.prod_change = false
		# workingDir = copy_source_files_to_working_dir(dojo.katas[session.cyberdojo_id].avatars[session.avatar].lights[index])

		# # puts "DDDDDDDDDDDD"
		# # puts @statement_coverage
		# curr.statement_coverage = @statement_coverage

		# # puts "CALCULATED SLOC:"
		# # puts @light_test_sloc
		# # puts  @light_prod_sloc

		# curr.test_sloc_count = @light_test_sloc
		# curr.production_sloc_count = @light_prod_sloc
		# curr.total_sloc_count = @light_test_sloc.to_i + @light_prod_sloc.to_i

		#Calculate Code Coverage for current Light
		# curr.statement_coverage = calc_code_covg(curr)

		#Calculate SLOC
		# calc_light_sloc(curr)

		#Aquire file changes from light
		if index == 0
		  diff = dojo.katas[session.cyberdojo_id].avatars[session.avatar].tags[0].diff(index)
		  curr.test_change = true
		else
		  diff = dojo.katas[session.cyberdojo_id].avatars[session.avatar].tags[index - 1].diff(index)
		end

		#Check for changes to Test or Prod code
		diff.each do |filename, content|
		  non_code_filenames = ['output', 'cyber-dojo.sh', 'instructions']
		  unless non_code_filenames.include?(filename)
		    if content.count { |line| line[:type] === :added } > 0 || content.count { |line| line[:type] === :deleted } > 0
		      #Check if file is a Test
		      if (filename.include?"Test") || (filename.include?"test") || (filename.include?"Spec") || (filename.include?"spec") || (filename.include?".t") || (filename.include?"Step") || (filename.include?"step")
		        curr.test_change = true
		      else
		        curr.prod_change = true
		      end
		    end
		  end
		end #End of Diff For Each

		#Count Lines Modified
		if index == 0 #If no previous light in this cycle use the last cycle's end
		  test_edits, code_edits = calc_lines(nil, dojo.katas[session.cyberdojo_id].avatars[session.avatar].lights[index], session)
		else
		  test_edits, code_edits = calc_lines(dojo.katas[session.cyberdojo_id].avatars[session.avatar].lights[index - 1], dojo.katas[session.cyberdojo_id].avatars[session.avatar].lights[index], session)
		end

		#Store Lines to Model
		curr.test_edited_line_count = test_edits
		curr.production_edited_line_count = code_edits
		curr.total_edited_line_count = test_edits + code_edits

		#Determine Time Spent
		if index == 0 #If the first light of the Kata
		  time_diff = dojo.katas[session.cyberdojo_id].avatars[session.avatar].lights[index].time - session.start_date
		else
		  time_diff = dojo.katas[session.cyberdojo_id].avatars[session.avatar].lights[index].time - dojo.katas[session.cyberdojo_id].avatars[session.avatar].lights[index - 1].time
		end

		#Drop Time if it hits the Time Ceiling
		if time_diff > @TIME_CEILING
		  time_diff = 0
		end

		#Store Time to Model
		curr.seconds_since_last_light = time_diff

		#################################
		#TODO: Count test methods in light
		#################################
		curr.total_test_method_count = 0

		#Count Failed Tests
		if index == 0
		  runtests, runtestfails = count_fails(nil, dojo.katas[session.cyberdojo_id].avatars[session.avatar].lights[index], session)
		else
		  runtests, runtestfails = count_fails(dojo.katas[session.cyberdojo_id].avatars[session.avatar].lights[index - 1], dojo.katas[session.cyberdojo_id].avatars[session.avatar].lights[index], session)
		end

		curr.total_test_run_count = runtests
		curr.total_test_run_fail_count = runtestfails

		curr.save
	end

end


def count_fails(prev, curr, session)

  runtests = 0
  runtestfails = 0

  #Take Diff
  if prev.nil? #If no previous light use the beginning
    diff = dojo.katas[session.cyberdojo_id].avatars[session.avatar].tags[0].diff(curr.number)
  else
    diff = dojo.katas[session.cyberdojo_id].avatars[session.avatar].tags[prev.number].diff(curr.number)
  end

  diff.each do |filename, content|
    if filename.include?"output"
    	content.each do |line|

		    case @language.to_s
			    when "Java-1.8_JUnit"
			      re = /\{:type=>:(added|same), :line=>\"Tests run: (?<tests>\d+),  Failures: (?<fails>\d+)\", :number=>\d+\}/
			      result = re.match(line.to_s)

			      unless result.nil?
			        runtests += result['tests'].to_i
			        runtestfails += result['fails'].to_i
			      end
			    end
      		end
    	end
  	end
end


def deleted_file(lines)
  return lines.all? { |line| line[:type] === :deleted }
end

def new_file(lines)
  return lines.all? { |line| line[:type] === :added }
end


def calc_lines(prev, curr, session)
  # determine number of lines changed between lights
  test_count = 0
  code_count = 0
  # regex for identifying edits and recording line_number
  re = /\{:type=>:(added|deleted), .* :number=>(?<line_number>\d+)\}/

  if prev.nil? #If no previous light use the beginning
    diff = dojo.katas[session.cyberdojo_id].avatars[session.avatar].tags[0].diff(curr.number)#@avatar.tags[0].diff(curr.number)
  else
    diff = dojo.katas[session.cyberdojo_id].avatars[session.avatar].tags[prev.number].diff(curr.number)#@avatar.tags[prev.number].diff(curr.number)
  end

  diff.each do |filename,lines|

    is_test = false
    line_counted = Array.new
    isFile = filename.match(/\.java$|\.py$|\.c$|\.cpp$|\.js$|\.php$|\.rb$|\.hs$|\.clj$|\.go$|\.scala$|\.coffee$|\.cs$|\.groovy$\.erl$/i)

    unless isFile.nil? || deleted_file(lines) || new_file(lines)
      lines.each do |line|
        begin
          case session.language_framework.to_s
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

      if @NEW_EDIT_COUNT #New way of counting
        lines.each do |line|
          output = re.match(line.to_s)
          unless output.nil?
            unless line_counted.include?output['line_number'].to_i
              line_counted.push(output['line_number'].to_i)
              if is_test
                test_count += 1
              else
                code_count += 1
              end
            end
          end
        end
      else #Old way of counting
        if is_test
          test_count += lines.count { |line| line[:type] === :added }
          test_count += lines.count { |line| line[:type] === :deleted }
        else
          code_count += lines.count { |line| line[:type] === :added }
          code_count += lines.count { |line| line[:type] === :deleted }
        end
      end

    end #End of Unless statment
  end #End of Diff For Each

  return test_count, code_count
end

desc "TODO"
task :calc_metrics => :environment do
  build_metric_data  
end