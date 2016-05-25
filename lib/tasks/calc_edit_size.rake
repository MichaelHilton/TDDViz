task :calc_edit_size do
  calc_edit_size
end

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
require_relative root + '/lib/ASTInterface/ASTInterface'


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


def calc_edit_size

#MARK SO QUERY CAN CONTINUE LATER
  #Compile.where(test_edited_line_count: 0).update_all(test_edited_line_count: -1)

  # Session.where(language_framework: "Java-1.8_JUnit").each do |session|
  #   SELECT DISTINCT(s.id) FROM sessions as s
  # INNER JOIN compiles as c on s.id = c.session_id
  # WHERE s.language_framework LIKE "Java-1.8_JUnit"
  # AND c.total_edited_line_count IS NULL
  # AND c.git_tag > 1

  #5768 runs out of memory

  Session.find_by_sql("SELECT s.* FROM sessions as s
  INNER JOIN compiles as c on s.id = c.session_id
  WHERE s.language_framework LIKE \"Java-1.8_JUnit\"
  AND c.test_edited_line_count < 0
  AND s.id != 5768").each do |session|

#TODO: FIX MAJOR ISSUES WITH RECOGNIZING STUFF


  # 7437
  FileUtils.remove_entry_secure(BUILD_DIR)

  # Session.find_by_sql("SELECT * FROM sessions WHERE id = 127").each do |session|

    # 735

    # puts session.inspect
    # puts "^^^^^^^^^^^^^^^^^^^  NEW Session  ^^^^^^^^^^^^^^^^^^^"
    # puts session.compiles.inspect
    # puts "^^^^^^^^^^^^^^^^^^^  NEW Session  ^^^^^^^^^^^^^^^^^^^"
    # puts session.compiles.first.inspect

    puts "^^^^^^^^^^^^^^^^^^^  NEW Session  ^^^^^^^^^^^^^^^^^^^"
    print "cyberdojo_id: " + session.cyberdojo_id.to_s + ", " if DEBUG
    print "language: " + session.language_framework.to_s + ", " if DEBUG
    print "avatar: " + session.avatar.to_s + "\n" if DEBUG

    #HANDLE THE FIRST COMPILE POINT
    puts session.compiles[0].inspect if DEBUG

    # puts dojo.katas[session.cyberdojo_id].avatars[session.avatar].lights[0]
    firstCompile = session.compiles.first
    curr_files = build_files(dojo.katas[session.cyberdojo_id].avatars[session.avatar].lights[0])
    curr_files = curr_files.select{ |filename| filename.include? ".java" }
    curr_filenames = curr_files.map{ |file| File.basename(file) }

    firstCompile.total_edited_line_count = 0
    firstCompile.production_edited_line_count = 0
    firstCompile.test_edited_line_count = 0
    firstCompile.save


    curr_path = "#{BUILD_DIR}/1/src"

    session.compiles.each_cons(2) do |prev, curr|
      puts "prev: " + prev.git_tag.to_s + " -> curr: " + curr.git_tag.to_s

      testChanges = false
      productionChanges = false
      test_AST_nodes = 0
      production_AST_nodes = 0


      prev_files = build_files(dojo.katas[session.cyberdojo_id].avatars[session.avatar].lights[prev.git_tag-1])
      curr_files = build_files(dojo.katas[session.cyberdojo_id].avatars[session.avatar].lights[curr.git_tag-1])

      # puts curr_files.inspect


      prev_files = prev_files.select{ |filename| filename.include? ".java" }
      curr_files = curr_files.select{ |filename| filename.include? ".java" }

      prev_filenames = prev_files.map{ |file| File.basename(file) }
      curr_filenames = curr_files.map{ |file| File.basename(file) }

      # testChanges = 0
      # productionChanges = 0
      # cycle for each prev_files that exists in curr_files, run diff
      curr_filenames.each do |filename|
        prev_path = "#{BUILD_DIR}/" + prev.git_tag.to_s + "/src"
        curr_path = "#{BUILD_DIR}/" + curr.git_tag.to_s + "/src"

        puts "filename:  " + filename

        match = false

        testChanges = false
        productionChanges = false

        if prev_filenames.include?(filename)
           match = true
         end
        #   if findChangeType(filename,prev_path,curr_path) == "Production"
        #     productionChanges = true
        #   end
        #   if findChangeType(filename,prev_path,curr_path) == "Test"
        #     testChanges = true
        #   end
        # else
          if findFileType(curr_path + "/" + filename) == "Production"
            productionChanges = true
          end
          if findFileType(curr_path + "/" + filename) == "Test"
            testChanges = true
          end
        # end


        puts "productionChanges: "+ productionChanges.to_s
        puts "testChanges: " + testChanges.to_s

        if match == true
          # puts "Total Number of Changes is: "
          diffASTResult = diffAST(prev_path + "/" + filename,curr_path + "/" + filename)
          if(diffASTResult != "ERROR")
          # puts "XXXXXXXXXXXXXXXXXXXXXXXX"
          puts "diffASTResult.length: " + JSON.parse(diffASTResult).length.to_s
          puts "XXXXXXXXXXXXXXXXXXXXXXXX"
          # puts diffASTResult
          puts "XXXXXXXXXXXXXXXXXXXXXXXX"
          unless diffASTResult == "ERROR"
            # puts JSON.parse(diffASTResult)
            # puts JSON.parse(diffASTResult).length

            if productionChanges
              puts "SET production_AST_nodes 1"
              production_AST_nodes += JSON.parse(diffASTResult).length
            elsif testChanges
              puts "SET test_AST_nodes 1"
              test_AST_nodes += JSON.parse(diffASTResult).length
              puts "test_AST_nodes: "+ test_AST_nodes.to_s
            else
              puts "++++++++++++++++++++ NOT PRODUCTION OR TEST CHANGE ++++++++++++++++++++"
            end
          else
            newAST = treeAST(curr_path + "/" + filename)

            unless newAST == "ERROR"

              if productionChanges
                puts "SET production_AST_nodes 2"
                production_AST_nodes += JSON.parse(newAST).length
              elsif testChanges
                puts "SET test_AST_nodes 2"
                test_AST_nodes += JSON.parse(newAST).length
              else
                puts "++++++++++++++++++++ NOT PRODUCTION OR TEST CHANGE ++++++++++++++++++++"
              end
            end
          end
          end
        end
      end

      puts "test_AST_nodes: "+ test_AST_nodes.to_s if DEBUG
      puts "production_AST_nodes: "+ production_AST_nodes.to_s if DEBUG

      curr.total_edited_line_count = test_AST_nodes + production_AST_nodes
      curr.production_edited_line_count = production_AST_nodes
      curr.test_edited_line_count = test_AST_nodes
      puts "CURR SAVE"
      curr.save
      puts "----------------------"

    end
     # FileUtils.remove_entry_secure(BUILD_DIR)
  end
end



# Session.where("id = ?", session_id.id).find_each do |session|
#   # Session.where("id = ?", 7871).find_each do |session|
#   # Session.includes(:compiles).where( :compiles => { :test_change => nil } ).find_each do |session|
#   # print "id: " + session.id.to_s + ", " if DEBUG
#   print "cyberdojo_id: " + session.cyberdojo_id.to_s + ", " if DEBUG
#   print "language: " + session.language_framework.to_s + ", " if DEBUG
#   print "avatar: " + session.avatar.to_s + "\n" if DEBUG

#   #HANDLE THE FIRST COMPILE POINT
#   puts session.compiles[0].inspect if DEBUG

#   # puts dojo.katas[session.cyberdojo_id].avatars[session.avatar].lights[0]
#   firstCompile = session.compiles.first
#   curr_files = build_files(dojo.katas[session.cyberdojo_id].avatars[session.avatar].lights[0])
#   curr_files = curr_files.select{ |filename| filename.include? ".java" }
#   curr_filenames = curr_files.map{ |file| File.basename(file) }

#   testChanges = false
#   productionChanges = false
#   firstCompile.total_method_count = 0
#   firstCompile.total_assert_count = 0

#   curr_path = "#{BUILD_DIR}/1/src"

#   if defaultSetup(curr_path)
#     productionChanges = false
#     testChanges = false
#     firstCompile.total_method_count = 0
#     firstCompile.total_assert_count = 0
#   else
#     curr_filenames.each do |filename|

#       puts curr_path + "/" + filename if DEBUG
#       if findFileType(curr_path + "/" + filename) == "Production"
#         productionChanges = true
#       end
#       if findFileType(curr_path + "/" + filename) == "Test"
#         testChanges = true
#       end
#       firstCompile.total_method_count += findMethods(curr_path + "/" + filename)
#       firstCompile.total_assert_count += findAsserts(curr_path + "/" + filename)
#     end
#   end
#   puts "testChanges: "+ testChanges.to_s if DEBUG
#   puts "productionChanges: "+ productionChanges.to_s if DEBUG

#   firstCompile.test_change = testChanges
#   firstCompile.prod_change = productionChanges
#   firstCompile.total_method_count
#   firstCompile.total_assert_count
#   firstCompile.save
#   puts "----------------------" if DEBUG


#   session.compiles.each_cons(2) do |prev, curr|
#     puts "prev: " + prev.git_tag.to_s + " -> curr: " + curr.git_tag.to_s

#     prev_files = build_files(dojo.katas[session.cyberdojo_id].avatars[session.avatar].lights[prev.git_tag-1])
#     curr_files = build_files(dojo.katas[session.cyberdojo_id].avatars[session.avatar].lights[curr.git_tag-1])

#     puts curr_files.inspect


#     prev_files = prev_files.select{ |filename| filename.include? ".java" }
#     curr_files = curr_files.select{ |filename| filename.include? ".java" }

#     prev_filenames = prev_files.map{ |file| File.basename(file) }
#     curr_filenames = curr_files.map{ |file| File.basename(file) }

#     testChanges = false
#     productionChanges = false
#     curr.total_method_count = 0
#     curr.total_assert_count = 0
#     # cycle for each prev_files that exists in curr_files, run diff
#     curr_filenames.each do |filename|
#       prev_path = "#{BUILD_DIR}/" + prev.git_tag.to_s + "/src"
#       curr_path = "#{BUILD_DIR}/" + curr.git_tag.to_s + "/src"

#       puts "File To Match" + filename

#       if prev_filenames.include?(filename)
#         if findChangeType(filename,prev_path,curr_path) == "Production"
#           productionChanges = true
#         end
#         if findChangeType(filename,prev_path,curr_path) == "Test"
#           testChanges = true
#         end
#       else
#         if findFileType(curr_path + "/" + filename) == "Production"
#           productionChanges = true
#         end
#         if findFileType(curr_path + "/" + filename) == "Test"
#           testChanges = true
#         end
#       end

#       #Calculate Number of methods and asserts
#       curr.total_method_count += findMethods(curr_path + "/" + filename)
#       curr.total_assert_count += findAsserts(curr_path + "/" + filename)

#     end
#     puts "testChanges: "+ testChanges.to_s if DEBUG
#     puts "productionChanges: "+ productionChanges.to_s if DEBUG

#     curr.test_change = testChanges
#     curr.prod_change = productionChanges
#     curr.total_method_count
#     curr.total_assert_count
#     puts "CURR SAVE"
#     curr.save
#     puts "----------------------"
#     FileUtils.remove_entry_secure(BUILD_DIR)
#   end

# end
# end














#     `rm -rf ./workingDir/*`

#     session.compiles.each_with_index do |compile, index|
#       puts "*******************  NEW COMPILE  *******************"
#       puts compile.inspect
#       # puts " "
#       # puts " "
#       # puts dojo.katas[session.cyberdojo_id].avatars[session.avatar].tags[0].diff(index)
#       # puts dojo.katas[session.cyberdojo_id].avatars[session.avatar].tags[index]

#       # puts " "
#       # puts " "

#       @avatar = dojo.katas[session.cyberdojo_id].avatars[session.avatar]
#       curr_light = @avatar.lights[index]
#       find_curr_file_diff_size(curr_light,compile)

#       # compile.total_test_run_count = @runtests
#       # compile.total_test_run_fail_count = @runtestfails
#       # compile.save

#     end
#   end
# end

# def find_curr_file_diff_size(curLight,compile)
#   # puts "COPY SOURCE FILES"
#   fileNames = curLight.tag.visible_files.keys
#   javaFiles = fileNames.select { |name|  name.include? "java" }
#   currLightDir =  "./workingDir/"+curLight.number.to_s


#   `mkdir ./workingDir/`
#   `mkdir #{currLightDir}`
#   `mkdir #{currLightDir}/src`

#   currTestClass = ""
#   javaFiles.each do |javaFileName|
#     File.open(currLightDir+"/src/"+javaFileName, 'w') {|f| f.write(curLight.tag.visible_files[javaFileName]) }
#     initialLoc = javaFileName.to_s =~ /test/i
#     unless initialLoc.nil?
#       fileNameParts = javaFileName.split('.')
#       currTestClass = fileNameParts.first
#     end
#   end
#   # @statement_coverage = calc_test_coverage_in_dir(curLight,currTestClass,currLightDir)

#   puts "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
#   puts "Current Light Color: " + curLight.colour.to_s
#   puts "statement_coverage: " + @statement_coverage.to_s
#   compile.statement_coverage = @statement_coverage
#   compile.test_sloc_count
#   puts "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
# end
