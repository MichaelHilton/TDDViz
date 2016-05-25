root = '../..'

require_relative root + '/config/environment.rb'
require_relative root + '/lib/Docker'
require_relative root + '/lib/DockerTestRunner'
require_relative root + '/lib/DummyTestRunner'
require_relative root + '/lib/Folders'
require_relative root + '/lib/Git'
require_relative root + '/lib/HostTestRunner'
require_relative root + '/lib/OsDisk'

class TddVizController < ApplicationController

  def index
  	  #@allSessions = Session.all		
		@allSessions = Session.where(language_framework: "Java-1.8_JUnit")
		allSessionsAndMarkup = Array.new
		@allSessions.each do |session|
			currSessionAndMarkup = Hash.new
			currSessionAndMarkup["session"] = session
			currSessionAndMarkup["markup"] = session.markups
			currSessionAndMarkup["compile_count"] = Array.new.push(session.compiles.count)
			allSessionsAndMarkup << currSessionAndMarkup
		end
		gon.allSessionsAndMarkup = allSessionsAndMarkup
  end



def display_kata
    #@session_id = params[:id]
     @researcher = params[:researcher]
     @cyberdojo_id = params[:id]
     @cyberdojo_avatar = params[:avatar]

    @currSession = Session.where(cyberdojo_id: @cyberdojo_id, avatar: @cyberdojo_avatar).first  #.first
    # @currSession = Session.where(id: @session_id).first

    puts "%%%%%%%%%%%%%%%% @currSession.inspect %%%%%%%%%%%%%%%%%%%"
    puts @currSession.inspect

    @cyberdojo_id = @currSession.cyberdojo_id
    @cyberdojo_avatar = @currSession.avatar

    gon.compiles = @currSession.compiles
    gon.cyberdojo_id = @cyberdojo_id
    gon.cyberdojo_avatar = @cyberdojo_avatar

    puts "%%%%%%%%%%%%%% @currSession.id %%%%%%%%%%%%%%%%%%%%%"
    puts @currSession.id

    allCycles = Array.new()
    Cycle.where(session_id: @currSession.id).each do |cycle|
      curr_cycle = Hash.new()
      # endCompile: 3startCompile: 1valid_tdd: true
      puts "CYCLE:!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
      # puts cycle.inspect
      # puts cycle.phases.first.compiles.first.git_tag.to_s
      firstCompile = cycle.phases.first.compiles.first
      lastCompile = cycle.phases.last.compiles.last
      unless lastCompile.nil?
        curr_cycle["startCompile"] = firstCompile.git_tag
        curr_cycle["endCompile"] = lastCompile.git_tag
        curr_cycle["valid_tdd"] = cycle.valid_tdd
        allCycles << curr_cycle
      end
    end
    gon.allCycles = allCycles

    normalizedPhaseTime = Array.new()
    normalizedPhaseSLOC = Array.new()
    allPhases  = Array.new

    totalCycleSloc = 0
    totalCycleTime = 0

    Cycle.where(session_id: @currSession.id).each do |cycle|
      currPhaseTime = Hash.new
      currPhaseSloc = Hash.new
      #Find Total Cycle Time
      # totalCycleSloc = 0
      # totalCycleTime = 0
      Phase.where(cycle_id: cycle.id).each do |phase|
        Compile.where(phase_id: phase.id).each do |compile|
          if phase.tdd_color == "red" || phase.tdd_color == "green" || phase.tdd_color == "blue"
            totalCycleSloc = totalCycleSloc + compile.total_sloc_count
            totalCycleTime = totalCycleTime + compile.seconds_since_last_light
          end
        end
      end

      total_sloc_count = 0
      seconds_in_phase = 0
      Phase.where(cycle_id: cycle.id).each do |phase|
        phaseHash = Hash.new()
        phaseHash["color"] = phase.tdd_color
        compilesInPhase = Array.new
        # puts "%%%%%%%%%%%%%%%%PHASE%%%%%%%%%%%%%%%%%%%"
        # puts compile.git_tag.to_s

        Compile.where(phase_id: phase.id).each do |compile|
          compilesInPhase << compile.git_tag
          # puts "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
          puts compile.git_tag.to_s
          total_sloc_count = total_sloc_count + compile.total_sloc_count
          seconds_in_phase = seconds_in_phase + compile.seconds_since_last_light
        end
        phaseHash["compiles"] = compilesInPhase
        allPhases << phaseHash

        currPhaseTime[phase.tdd_color] = total_sloc_count.to_f/totalCycleSloc.to_f
        currPhaseSloc[phase.tdd_color] = seconds_in_phase.to_f/totalCycleTime.to_f
      end
      normalizedPhaseTime.push(currPhaseTime)
      normalizedPhaseSLOC.push(currPhaseSloc)
    end

    gon.phases = allPhases

    gon.normalizedPhaseTime = normalizedPhaseTime
    gon.normalizedPhaseSLOC = normalizedPhaseSLOC
  end


end
