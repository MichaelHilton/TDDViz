task :calc_phase_stats do
  calc_phase_stats
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



def calc_phase_stats

  Phase.all.each do |phase|
    puts "^^^^^^^^^^^^^^^^^^^  NEW PHASE  ^^^^^^^^^^^^^^^^^^^"
    # puts phase.inspect

    # puts phase.compiles.first.light_color.to_s

    seconds_in_phase = 0
    total_edit_count = 0
    production_edit_count = 0
    test_edit_count = 0
    total_sloc_count = 0
    production_sloc_count = 0
    test_sloc_count = 0
    total_line_change_count = 0
    production_line_change_count = 0
    test_line_change_count = 0
    first_compile_in_phase = nil
    last_compile_in_phase = nil


    puts "!!!!!!!!!!!! Compiles !!!!!!!!!!!!"
    phase.compiles.each_with_index do |compile, index|

      if phase.compiles.length > 0

        # puts compile.inspect
        puts "compile.seconds_since_last_light: "+compile.seconds_since_last_light.to_s
        seconds_in_phase += compile.seconds_since_last_light

        if(compile.total_edited_line_count != nil)
          puts "compile.total_edited_line_count: "+compile.total_edited_line_count.to_s
          total_edit_count += compile.total_edited_line_count
        end



        # production_edit_count
        if(compile.production_edited_line_count != nil)
          puts "compile.production_edited_line_count: "+compile.production_edited_line_count.to_s
          production_edit_count += compile.production_edited_line_count
        end


        # test_edit_count
        if(compile.test_edited_line_count != nil)
          puts "compile.test_edited_line_count: "+compile.test_edited_line_count.to_s
          test_edit_count += compile.test_edited_line_count
        end


        # total_sloc_count
        if(compile.total_sloc_count != nil)
          puts "compile.total_sloc_count: "+compile.total_sloc_count.to_s
          total_sloc_count = compile.total_sloc_count
        end

        # production_sloc_count
        if(compile.production_sloc_count != nil)
          puts "compile.production_sloc_count: "+compile.production_sloc_count.to_s
          production_sloc_count = compile.production_sloc_count
        end

        # test_sloc_count
        if(compile.test_sloc_count != nil)
          puts "compile.test_sloc_count: "+compile.test_sloc_count.to_s
          test_sloc_count = compile.test_sloc_count
        end

        # total_line_change_count
        if(compile.test_sloc_count != nil)
          puts "compile.test_sloc_count: "+compile.test_sloc_count.to_s
          test_sloc_count = compile.test_sloc_count
        end

        # production_line_change_count
        if(compile.test_sloc_count != nil)
          puts "compile.test_sloc_count: "+compile.test_sloc_count.to_s
          production_line_change_count = compile.test_sloc_count
        end

        # test_line_change_count
        # first_compile_in_phase
        # last_compile_in_phase
      end

      # first_compile_in_phase
      # last_compile_in_phase

      phase.seconds_in_phase = seconds_in_phase
      phase.total_edit_count = total_edit_count
      phase.production_edit_count = production_edit_count
      phase.test_edit_count = test_edit_count
      phase.total_sloc_count = total_sloc_count
      phase.production_sloc_count = production_sloc_count
      phase.test_sloc_count = test_sloc_count


      # puts phase.compiles.first.inspect
      # puts phase.compiles.inspect
      # puts phase.compiles.length
      phase.first_compile_in_phase =  phase.compiles.first.id
      phase.last_compile_in_phase = phase.compiles.last.id

      phase.save
    end

  end

end


# Session.find_by_sql("SELECT s.id,s.kata_name,s.cyberdojo_id,s.avatar FROM Sessions as s INNER JOIN interrater_sessions as i on i.session_id = s.id").each do |session_id|
#   # Session.find_by_sql("SELECT s.id,s.kata_name,s.cyberdojo_id,s.avatar FROM Sessions as s WHERE s.id = 9").each do |session_id|
#   # Session.find_by_sql("SELECT s.id,s.kata_name,s.cyberdojo_id,s.avatar FROM Sessions as s").each do |session_id|

#   puts "CURR SESSION ID: " + session_id.id.to_s if CYCLE_DIAG

#   FileUtils.remove_entry_secure(BUILD_DIR)

#   Session.where("id = ?", session_id.id).find_each do |curr_session|
#     # Session.where("id = ?", 2456).find_each do |curr_session|

#     lastTime = nil
#     curr_session.compiles.each_with_index do |compile, index|
#       sloc = 0
#       production_sloc = 0
#       test_sloc = 0
#       # puts compile.inspect
#       puts "compile.git_tag: "+ compile.git_tag.to_s
#       puts "index: "+ index.to_s

#       curr_light = dojo.katas[curr_session.cyberdojo_id].avatars[curr_session.avatar].lights[index]
#       curr_files = build_files(curr_light)
#       curr_files = curr_files.select{ |filename| filename.include? ".java" }
#       curr_filenames = curr_files.map{ |file| File.basename(file) }
#       path = "#{BUILD_DIR}/" + compile.git_tag.to_s + "/src"

#       Dir.entries(path).each do |currFile|
#         # unless currFile.nil?
#         # puts "currFile: " + currFile.to_s
#         if currFile.to_s.length > 3
#           file = path.to_s + "/" + currFile.to_s
#           command = `./cloc-1.62.pl --by-file --quiet --sum-one --exclude-list-file=./clocignore --csv #{file}`
#           # puts "./cloc-1.62.pl --by-file --quiet --sum-one --exclude-list-file=./clocignore --csv #{file}"
#           # puts `pwd`
#           # puts command
#           csv = CSV.parse(command)
#           # puts " csv.to_s: " + csv.to_s
#           unless(csv.inspect == "[]")

#             begin
#               # puts "File Type: " + findFileType(file)
#               if findFileType(file) == "Production"
#                 # puts "sloc: " + csv[2][4].to_i.to_s

#                 production_sloc = production_sloc + csv[2][4].to_i
#                 # puts "PRODUCTION SLOC: " + production_sloc.to_s
#               end
#               if findFileType(file) == "Test"
#                 test_sloc = test_sloc + csv[2][4].to_i
#                 # puts "TEST SLOC: " + test_sloc.to_s
#               end
#             rescue
#               # puts "Error: Reading in calc_sloc"
#             end
#             sloc = sloc + csv[2][4].to_i
#           end
#         end
#       end
#       puts "production_sloc: " + production_sloc.to_s
#       puts "test_sloc: "+ test_sloc.to_s
#       puts "SLOC: "+sloc.to_s
#       compile.test_sloc_count = test_sloc.to_s
#       compile.total_sloc_count = sloc.to_s
#       compile.production_sloc_count = production_sloc.to_s

#       puts "SAVED COMPILE: " + compile.id.to_s

#       puts "$$$$$$$$$$$$$$$$$$$$ CompileTime $$$$$$$$$$$$$$$$$$$$"
#       puts curr_light.time
#       timeDiff = 0
#       if index>0
#         timeDiff = curr_light.time - lastTime
#         puts "timeDiff: " + timeDiff.to_s

#       end
#       lastTime = curr_light.time
#       if timeDiff > 300
#         timeDiff = 300
#       end
#       compile.seconds_since_last_light = timeDiff
#       compile.save
#       puts "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"



#     end
#   end
# end
# end
