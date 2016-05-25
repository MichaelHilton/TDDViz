root = '../'
require 'set'
require 'fileutils'
require_relative root + 'ASTInterface/ASTInterface'
require_relative root + 'OsDisk'      # required for dojo definition
require_relative root + 'Git'       # required for dojo definition
require_relative root + 'DummyTestRunner' # required for dojo definition



desc "parse Java project files and git to determine # of methods and # of asserts at each compile"
task :find_final_AST_node_size => :environment do
  find_final_AST_node_size
end

def find_final_AST_node_size

  FileUtils.mkdir_p BUILD_DIR, :mode => 0700

  Session.find_by_sql("SELECT * FROM Sessions as s WHERE language_framework LIKE \"Java-1.8_JUnit\"").each do |session|
    lastCompile = session.compiles.last
    puts lastCompile.inspect

    last_git_dir = lastCompile.git_tag

    curr_files = build_files(dojo.katas[session.cyberdojo_id].avatars[session.avatar].lights[last_git_dir-1])

    curr_files = curr_files.select{ |filename| filename.include? ".java" }

    curr_filenames = curr_files.map{ |file| File.basename(file) }

    final_production_AST_node_count = 0
    final_test_AST_node_count = 0
    final_total_AST_node_count = 0

    #     add_column :sessions, :final_production_AST_node_count, :float
    # add_column :sessions, :final_test_AST_node_count, :float
    # add_column :sessions, :final_total_AST_node_count, :float

    curr_path = "#{BUILD_DIR}/"+last_git_dir.to_s+"/src"

    curr_filenames.each do |filename|

      if findFileType(curr_path + "/" + filename) == "Production"
        final_production_AST_node_count += findAllNodeCount(curr_path + "/" + filename)
      end
      if findFileType(curr_path + "/" + filename) == "Test"
        final_test_AST_node_count += findAllNodeCount(curr_path + "/" + filename)
      end

    end



    session.final_production_AST_node_count = final_production_AST_node_count
    session.final_test_AST_node_count = final_test_AST_node_count
    session.final_total_AST_node_count = final_test_AST_node_count + final_production_AST_node_count
    session.save

    puts "final_production_file_method_count: " + final_production_AST_node_count.to_s
    puts "final_test_AST_node_count:"+ final_test_AST_node_count.to_s
    puts "final_total_AST_node_count:" + final_total_AST_node_count.to_s

    FileUtils.remove_entry_secure(BUILD_DIR)
  end
end
