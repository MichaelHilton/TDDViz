task :calc_session_TDD_Percentage do
  calc_session_TDD_Percentage
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



def calc_session_TDD_Percentage

  Session.where(language_framework: "Java-1.8_JUnit").each do |session|
    puts "*******************  NEW CYCLE  *******************"
    puts session.inspect

    total_number_of_compiles = session.compiles.count
    total_number_of_TDD_compiles = 0


    session.cycles.each do |cycle|
      cycle.phases.each do |phase|

        if phase.tdd_color !=  "white"
          total_number_of_TDD_compiles += phase.compiles.count
        end         
      end
    end

    puts "total_number_of_compiles: "+total_number_of_compiles.to_s
    puts "total_number_of_TDD_compiles: "+total_number_of_TDD_compiles.to_s

    session.tdd_score = total_number_of_TDD_compiles.to_f / total_number_of_compiles.to_f
    session.save
  end
end
