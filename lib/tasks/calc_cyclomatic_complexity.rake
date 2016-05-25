task :calc_cyclomatic_complexity do
  calc_cyclomatic_complexity
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



def calc_cyclomatic_complexity

  #add javancss to classpath.
  # export CLASSPATH="$CLASSPATH:/home/tddstudy/TDDStudy/vendor/assets/jars/*"

  Session.where(language_framework: "Java-1.8_JUnit").each do |session|
    # path = "#{BUILD_DIR}/" + light.number.to_s + "/src"

    # puts "*******************  NEW CYCLE  *******************"
    # puts session.inspect
    puts session.id.to_s

    lastCompile = session.compiles.last
    index = (session.compiles.count)-1
    total_cc = 0
    production_cc = 0
    test_cc = 0
    curr_light = dojo.katas[session.cyberdojo_id].avatars[session.avatar].lights[index]
    curr_files = build_files(curr_light)
    curr_files = curr_files.select{ |filename| filename.include? ".java" }
    curr_filenames = curr_files.map{ |file| File.basename(file) }
    path = "#{BUILD_DIR}/" + lastCompile.git_tag.to_s + "/src"
    FileUtils.mkdir_p BUILD_DIR, :mode => 0700
    cycloText = ""


    totalProdMethods = 0.0
    totalTestMethods = 0.0
    avgProdCC = 0.0
    avgTestCC = 0.0
    javaNCSSHash = nil

    Dir.entries(path).each do |currFile|
      if currFile.to_s.length > 3
        file = path.to_s + "/" + currFile.to_s
        # puts "output"
        # puts "./vendor/complexity/javancss -function  -package -xml #{file}"
        cycloText =  `./vendor/complexity/javancss -function  -package -xml #{file}`
        javaNCSSHash = Hash.from_xml(cycloText)
        if javaNCSSHash
          # puts "^^^^^^^^^^^^^^^^^^^^^^javaNCSSHash[javancss]:^^^^^^^^^^^^^^^^^^^^^^"
          numberOfFunctions = 0
          avgCC = 0
          numberOfFunctions =  javaNCSSHash["javancss"]["packages"]["package"]["functions"]
          avgCC = javaNCSSHash["javancss"]["functions"]["function_averages"]["ccn"]

          # puts "numberOfFunctions:"+numberOfFunctions.to_s
          # puts "avgCC:"+avgCC.to_s


          if findFileType(file) == "Production"
            # puts "Production"
            prevProdCC = avgProdCC
            # puts "totalProdMethods:"+ totalProdMethods.to_s
            # puts "numberOfFunctions:"+ numberOfFunctions.to_s
            # puts "avgProdCC:"+ avgProdCC.to_s
            # puts "avgCC:"+ avgCC.to_s
            avgProdCC = ((avgProdCC.to_f * totalProdMethods.to_f) + (avgCC.to_f*numberOfFunctions.to_f))/(totalProdMethods.to_f + numberOfFunctions.to_f)
          totalProdMethods += numberOfFunctions.to_i
          # puts "avgProdCC:"+avgProdCC.to_s
          # puts "totalProdMethods:"+totalProdMethods.to_s
        end
        if findFileType(file) == "Test"
          # puts "Test"
          prevTestCC = avgTestCC
          avgTestCC = ((avgTestCC.to_f * totalTestMethods.to_f) + (avgCC.to_f*numberOfFunctions.to_f))/(totalTestMethods.to_f + numberOfFunctions.to_f)
            totalTestMethods += numberOfFunctions.to_i
            # puts "avgTestCC:"+avgTestCC.to_s
            # puts "totalTestMethods:"+totalTestMethods.to_s
          end
        end
      end
    end

    if avgProdCC.nan?
      avgProdCC = 0
    end
    if avgTestCC.nan?
      avgTestCC = 0
    end

    if totalTestMethods > 0 || totalProdMethods > 0
      total_avg_cc = ((avgTestCC * totalTestMethods)+(avgProdCC * totalProdMethods))/(totalProdMethods + totalTestMethods)
    else
      total_avg_cc = 0
    end




    # puts "production_cc: " + avgProdCC.to_s
    # puts "test_cc: "+ avgTestCC.to_s
    # puts "total_cc: "+total_avg_cc.to_s
    session.test_cyclomatic_complexity = avgTestCC
    session.production_cyclomatic_complexity = avgProdCC
    session.final_cyclomatic_complexity = total_avg_cc

    session.save
    FileUtils.remove_entry_secure(BUILD_DIR)
  end
end
