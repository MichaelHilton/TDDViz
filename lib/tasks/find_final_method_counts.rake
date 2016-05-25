root = '../'
require 'set'
require 'fileutils'
require_relative root + 'ASTInterface/ASTInterface'
require_relative root + 'OsDisk'      # required for dojo definition
require_relative root + 'Git'       # required for dojo definition
require_relative root + 'DummyTestRunner' # required for dojo definition



desc "parse Java project files and git to determine # of methods and # of asserts at each compile"
task :find_final_method_counts => :environment do
  find_final_method_counts
end

def find_final_method_counts

  FileUtils.mkdir_p BUILD_DIR, :mode => 0700

  Session.find_by_sql("SELECT * FROM Sessions as s WHERE language_framework LIKE \"Java-1.8_JUnit\"").each do |session|
    lastCompile = session.compiles.last
    puts lastCompile.inspect

    last_git_dir = lastCompile.git_tag

    curr_files = build_files(dojo.katas[session.cyberdojo_id].avatars[session.avatar].lights[last_git_dir-1])

    curr_files = curr_files.select{ |filename| filename.include? ".java" }

    curr_filenames = curr_files.map{ |file| File.basename(file) }

    final_production_file_method_count = 0
    final_test_file_method_count = 0
    final_total_method_count = 0

    curr_path = "#{BUILD_DIR}/"+last_git_dir.to_s+"/src"

    curr_filenames.each do |filename|

      if findFileType(curr_path + "/" + filename) == "Production"
        final_production_file_method_count += findMethods(curr_path + "/" + filename)
      end
      if findFileType(curr_path + "/" + filename) == "Test"
        final_test_file_method_count += findMethods(curr_path + "/" + filename)
      end

    end

    puts "final_production_file_method_count: " + final_production_file_method_count.to_s
    puts "final_test_file_method_count:"+ final_test_file_method_count.to_s
    puts "final_total_method_count:" + final_total_method_count.to_s

    session.final_production_file_method_count = final_production_file_method_count
    session.final_test_file_method_count = final_test_file_method_count
    session.final_total_method_count = final_test_file_method_count + final_production_file_method_count
    session.save

    FileUtils.remove_entry_secure(BUILD_DIR)
  end
end


# Session.find_by_sql("SELECT * FROM Sessions as s").each do |session|

#     #HANDLE THE FIRST COMPILE POINT
#     # puts session.compiles[0].inspect if DEBUG

#     # puts dojo.katas[session.cyberdojo_id].avatars[session.avatar].lights[0]
#     firstCompile = session.compiles.first
#     curr_files = build_files(dojo.katas[session.cyberdojo_id].avatars[session.avatar].lights[0])
#     curr_files = curr_files.select{ |filename| filename.include? ".java" }
#     curr_filenames = curr_files.map{ |file| File.basename(file) }

#     testChanges = false
#     productionChanges = false
#     firstCompile.total_method_count = 0
#     firstCompile.total_assert_count = 0

#     curr_path = "#{BUILD_DIR}/1/src"

#     if defaultSetup(curr_path)
#       productionChanges = false
#       testChanges = false
#       firstCompile.total_method_count = 0
#       firstCompile.total_assert_count = 0
#     else
#       curr_filenames.each do |filename|

#         puts curr_path + "/" + filename if DEBUG
#         if findFileType(curr_path + "/" + filename) == "Production"
#           productionChanges = true
#         end
#         if findFileType(curr_path + "/" + filename) == "Test"
#           testChanges = true
#         end
#         firstCompile.total_method_count += findMethods(curr_path + "/" + filename)
#         firstCompile.total_assert_count += findAsserts(curr_path + "/" + filename)
#       end
#     end
#     puts "testChanges: "+ testChanges.to_s if DEBUG
#     puts "productionChanges: "+ productionChanges.to_s if DEBUG

#     firstCompile.test_change = testChanges
#     firstCompile.prod_change = productionChanges
#     firstCompile.total_method_count
#     firstCompile.total_assert_count
#     firstCompile.save
#     puts "----------------------" if DEBUG


#     session.compiles.each_cons(2) do |prev, curr|
#       puts "prev: " + prev.git_tag.to_s + " -> curr: " + curr.git_tag.to_s

#       prev_files = build_files(dojo.katas[session.cyberdojo_id].avatars[session.avatar].lights[prev.git_tag-1])
#       curr_files = build_files(dojo.katas[session.cyberdojo_id].avatars[session.avatar].lights[curr.git_tag-1])

#       puts curr_files.inspect


#       prev_files = prev_files.select{ |filename| filename.include? ".java" }
#       curr_files = curr_files.select{ |filename| filename.include? ".java" }

#       prev_filenames = prev_files.map{ |file| File.basename(file) }
#       curr_filenames = curr_files.map{ |file| File.basename(file) }

#       testChanges = false
#       productionChanges = false
#       curr.total_method_count = 0
#       curr.total_assert_count = 0
#       # cycle for each prev_files that exists in curr_files, run diff
#       curr_filenames.each do |filename|
#         prev_path = "#{BUILD_DIR}/" + prev.git_tag.to_s + "/src"
#         curr_path = "#{BUILD_DIR}/" + curr.git_tag.to_s + "/src"

#         puts "File To Match" + filename

#         if prev_filenames.include?(filename)
#           if findChangeType(filename,prev_path,curr_path) == "Production"
#             productionChanges = true
#           end
#           if findChangeType(filename,prev_path,curr_path) == "Test"
#             testChanges = true
#           end
#         else
#           if findFileType(curr_path + "/" + filename) == "Production"
#             productionChanges = true
#           end
#           if findFileType(curr_path + "/" + filename) == "Test"
#             testChanges = true
#           end
#         end

#         #Calculate Number of methods and asserts
#         curr.total_method_count += findMethods(curr_path + "/" + filename)
#         curr.total_assert_count += findAsserts(curr_path + "/" + filename)

#       end
#       puts "testChanges: "+ testChanges.to_s if DEBUG
#       puts "productionChanges: "+ productionChanges.to_s if DEBUG

#       curr.test_change = testChanges
#       curr.prod_change = productionChanges
#       curr.total_method_count
#       curr.total_assert_count
#       puts "CURR SAVE"
#       curr.save
#       puts "----------------------"
#       FileUtils.remove_entry_secure(BUILD_DIR)
#     end


# end


# end
