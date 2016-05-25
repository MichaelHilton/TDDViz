task :calc_cycle_data do
  calc_cycle_data
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



def calc_cycle_data

  Cycle.all.each do |cycle|
    puts "*******************  NEW CYCLE  *******************"
    puts cycle.inspect


      # t.integer :total_edit_count
      # t.integer :production_edit_count
      # t.integer :test_edit_count
      # t.integer :total_sloc_count
      # t.integer :production_sloc_count
      # t.integer :test_sloc_count
      # t.float :statement_coverage
      # t.integer :cyclomatic_complexity
      # t.boolean :valid_tdd
      # t.integer :cycle_position

    total_edit_count = 0
    production_edit_count = 0
    test_edit_count = 0
    total_sloc_count = 0
    production_sloc_count = 0
    test_sloc_count = 0
    statement_coverage = 0
    cyclomatic_complexity = 0
    valid_tdd = 0
    # statement_coverage = 0

    cycle.phases.each do |phase|

      unless phase.seconds_in_phase.nil?

        puts "&&&&&&&&&&&&&&&&&&&&& phase"
        puts phase.inspect

        total_edit_count += phase.total_edit_count
        production_edit_count += phase.production_edit_count
        test_edit_count += phase.test_edit_count
        total_sloc_count += phase.total_sloc_count 
        production_sloc_count += phase.production_sloc_count
        test_sloc_count += phase.test_sloc_count
        # statement_coverage = phase.statement_coverage
      end
      # cyclomatic_complexity = 0
      # valid_tdd = 0
    end

    # cycle.statement_coverage = last.statement_coverage
    unless cycle.phases.last.compiles.last.nil?
    cycle.statement_coverage = cycle.phases.last.compiles.last.statement_coverage
  end
    cycle.total_edit_count = total_edit_count
    cycle.production_edit_count = production_edit_count
    cycle.test_edit_count = test_edit_count
    cycle.total_sloc_count = total_sloc_count 
    cycle.production_sloc_count = production_sloc_count
    cycle.test_sloc_count = test_sloc_count
    cycle.save
  end


end
