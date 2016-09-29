root = '../..'

require_relative root + '/config/environment.rb'
require_relative root + '/lib/Docker'
require_relative root + '/lib/DockerTestRunner'
require_relative root + '/lib/DummyTestRunner'
require_relative root + '/lib/Folders'
require_relative root + '/lib/Git'
require_relative root + '/lib/HostTestRunner'
require_relative root + '/lib/OsDisk'

class MarkupController < ApplicationController

  skip_before_filter  :verify_authenticity_token


  def index
    @researchers = Researcher.all
  end


  def index_simple
    # @sessions = Session.where(language_framework: "Java-1.8_JUnit")
    #find_by_sql
    @sessions = Session.find_by_sql("SELECT (select Count(*) from cycles as c where c.session_id = s.id)as a,* FROM sessions as s WHERE a > 5 AND s.language_framework LIKE \"Java-1.8_JUnit\"")
    #@sessions = Session.where(language_framework: "Java-1.8_JUnit")
    #SELECT (select Count(*) from cycles as c where c.session_id = s.id)as a,* FROM sessions as s WHERE a > 5
  end

  def dojo
    externals = {
      :disk   => OsDisk.new,
      :git    => Git.new,
      :runner => DummyTestRunner.new
    }
    Dojo.new(root_path,externals)
  end

  def root_path
    Rails.root.to_s + '/'
  end


  def display_AST_tree
    id = params[:id]
    gitTag = params[:gitTag]
    filename= params[:filename]

    @AST_Tree = AstTree.find_by(session_id: id,git_tag: gitTag, filename: filename)
    # nextAST_tree = AstTree.find_by(session_id: id,git_tag: gitTag.to_i+1, filename: filename)
    returnArray = Array.new
    returnArray.push(@AST_Tree.fullJSONTree(@AST_Tree.id))
    gon.astTree = returnArray
  end


  def mark_completed
    @kata = params[:kata]
    researcher_id = Researcher.find_by(name: @researcher).id
    allSessions = Session.where(language_framework: "Java-1.8_JUnit", kata_name: "Fizz_Buzz", potential_complete: true)
    gon.allSessions = allSessions

  end

  def markKata
    id = params[:id]
    currSession = Session.where(id: id).first

    puts currSession.inspect
    puts currSession.cyberdojo_id

    allFiles = dojo.katas[currSession.cyberdojo_id].avatars[currSession.avatar].lights[currSession.total_light_count.to_i-1].tag.visible_files

    gon.allFiles = allFiles
    gon.is_complete = currSession.is_complete

  end

  def update_completion
    puts "%%%%%%%%%%%%%%%%%%update_markup$$$$$$$$$$$$$$$$$$"
    puts params[:complete]
    curr_id =  params[:id]

    currSession = Session.where(id: curr_id).first

    if params[:complete] == "Yes"
      currSession.is_complete = true
    end
    if params[:complete] == "No"
      currSession.is_complete = false
    end



    currSession.save


    names = Array.new
    respond_to do |format|
      format.html
      # format.json { render :json => @oneSession }
      format.json { render :json => names }
    end
  end

  def calculatePrecisionAndRecall(session)
    puts "%%%%%%%%%%%%%%%%%%%%%%%%% Recall %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
    puts "Session.markups.count: " + session.markups.count.to_s
    if(session.markups.count == 0)
      returnValues = Array.new
      returnValues[0] = "NA"
      returnValues[1] = "NA"
      return returnValues
    end
    #calc recall
    compileColor = Hash.new
    session.cycles.each do |cycle|
      # puts cycle.inspect
      cycle.phases.each do |phase|
        phase.compiles.each do |compile|
          compileColor[compile.git_tag] = phase.tdd_color
        end
      end
    end
    numMarkupCompiles = compileColor.keys.length
    totalMarkups = session.compiles.length
    # puts compileColor.inspect
    # puts "Number of Markups: "+ numMarkupCompiles.to_s
    # puts "Number of Compile Points: "+ totalMarkups.to_s



    #calc precision
    puts "%%%%%%%%%%%%%%%%%%%%%%%%% Precision %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
    # puts session.markups.first.inspect
    numCorrect = 0
    numIncorrect = 0
    recallWrong = 0
    recallRight = 0

    if session.markups.count > 0
      aMarkupUser =  session.markups.select(:user).distinct.first.user
      # puts "markupUser: "+ aMarkupUser
      # puts "Session id: " + session.id.to_s
      allUserMarkups = Markup.where(user: aMarkupUser, session_id: session.id)

      # puts "Hash: " + compileColor.inspect
      # puts allUserMarkups.inspect



      allUserMarkups.each do |markup|
        # puts markup.inspect
        # puts "markup.first_compile_in_phase: " + markup.first_compile_in_phase.to_s
        # puts "markup.last_compile_in_phase: " + markup.last_compile_in_phase.to_s
        # puts "markup.tdd_color: " + markup.tdd_color.to_s
        # # for
        for i in (markup.first_compile_in_phase+1)..markup.last_compile_in_phase
          # puts i
          puts "compileColor[i].to_s: "+ compileColor[i].to_s
          puts "markup.tdd_color.to_s: " + markup.tdd_color.to_s
          if markup.tdd_color.to_s != "white"
            puts "WHITE COMPILE"
            if compileColor[i].to_s == "white"
              puts "RECALL WRONG"
              recallWrong = recallWrong +1
            else
              puts "RECALL WRITE"
              recallRight = recallRight + 1
            end
          end

          if(compileColor[i].to_s == markup.tdd_color.to_s)
            numCorrect = numCorrect + 1
          else
            numIncorrect = numIncorrect + 1
          end
        end
      end
      # recall = (numMarkupCompiles.to_f/totalMarkups.to_f)
      @recall = (recallRight.to_f/(recallRight.to_f + recallWrong.to_f))
      puts "Recall:" + @recall.to_s
      returnValues = Array.new
      returnValues[1] = @recall

      puts "numCorrect: "+ numCorrect.to_s
      puts "numIncorrect: "+ numIncorrect.to_s
      precision = (numCorrect.to_f/(numCorrect.to_f + numIncorrect.to_f))
      puts "Precision: " + precision.to_s
      returnValues[0] = precision
    end

    @totalNumCorrect = @totalNumCorrect + numCorrect
    @totalNumInCorrect = @totalNumInCorrect + numIncorrect
    @totalCompiles = @totalCompiles + totalMarkups
    @totalMarkedCompiles = @totalMarkedCompiles + numMarkupCompiles
    @totalRecall = @totalRecall + recallRight
    @totalRecallWrong = @totalRecallWrong + recallWrong
    puts "%%%%%%%%%%%%%%%%%%%%%%%%% END %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
    return returnValues
  end

  def researcher
    @researcher = params[:researcher]
    if @researcher == "All"
      puts "ALL"

      # researcher_id = Researcher.find_by(name: @researcher).id
      all_sessions_markup = Array.new

      @totalNumCorrect = 0
      @totalNumInCorrect = 0
      @totalCompiles = 0
      @totalMarkedCompiles = 0
      @totalRecall = 0
      @totalRecallWrong = 0

      @inter_sessions = InterraterSession.all
      @inter_sessions.each do |interrater|
        session = Session.find_by(id: interrater.session_id)
        p_and_r = calculatePrecisionAndRecall(session)
        # puts p_and_r.inspect
        # puts p_and_r[1]
        curr_session_markup = Hash.new
        curr_session_markup["precision"] = p_and_r[0]
        curr_session_markup["recall"] = p_and_r[1]
        curr_session_markup["interRater"] = true
        curr_session_markup["session"] = session
        curr_session_markup["markup"] = session.markups
        curr_session_markup["compile_count"] = Array.new.push(session.compiles.count)
        all_sessions_markup << curr_session_markup
      end

      @markup_sessions = MarkupAssignment.all
      @markup_sessions.each do |assignment|
        session = Session.find_by(id: assignment.session_id)
        p_and_r = calculatePrecisionAndRecall(session)
        curr_session_markup = Hash.new
        curr_session_markup["precision"] =  p_and_r[0]
        curr_session_markup["recall"] =  p_and_r[1]
        curr_session_markup["interRater"] = false
        curr_session_markup["session"] = session
        curr_session_markup["markup"] = session.markups
        curr_session_markup["compile_count"] = Array.new.push(session.compiles.count)
        all_sessions_markup << curr_session_markup
      end

      gon.all_sessions_markup = all_sessions_markup
      gon.totalNumCorrect = @totalNumCorrect
      gon.totalNumInCorrect = @totalNumInCorrect
      gon.totalCompiles = @totalCompiles
      gon.totalMarkedCompiles = @totalMarkedCompiles

      gon.totalRecall = @totalRecall
      gon.totalRecallWrong = @totalRecallWrong



    else

      researcher_id = Researcher.find_by(name: @researcher).id
      all_sessions_markup = Array.new

      @totalNumCorrect = 0
      @totalNumInCorrect = 0
      @totalCompiles = 0
      @totalMarkedCompiles = 0
      @totalRecall = 0
      @totalRecallWrong = 0


      @inter_sessions = InterraterSession.all
      @inter_sessions.each do |interrater|
        session = Session.find_by(id: interrater.session_id)
        p_and_r = calculatePrecisionAndRecall(session)
        # puts p_and_r.inspect
        # puts p_and_r[1]
        curr_session_markup = Hash.new
        curr_session_markup["precision"] = p_and_r[0]
        curr_session_markup["recall"] = p_and_r[1]
        curr_session_markup["interRater"] = true
        curr_session_markup["session"] = session
        curr_session_markup["markup"] = session.markups
        curr_session_markup["compile_count"] = Array.new.push(session.compiles.count)
        all_sessions_markup << curr_session_markup
      end

      @markup_sessions = MarkupAssignment.where(researcher_id: researcher_id)
      @markup_sessions.each do |assignment|
        session = Session.find_by(id: assignment.session_id)
        p_and_r = calculatePrecisionAndRecall(session)
        curr_session_markup = Hash.new
        curr_session_markup["precision"] =  p_and_r[0]
        curr_session_markup["recall"] =  p_and_r[1]
        curr_session_markup["interRater"] = false
        curr_session_markup["session"] = session
        curr_session_markup["markup"] = session.markups
        curr_session_markup["compile_count"] = Array.new.push(session.compiles.count)
        all_sessions_markup << curr_session_markup
      end

      gon.all_sessions_markup = all_sessions_markup
      gon.totalNumCorrect = @totalNumCorrect
      gon.totalNumInCorrect = @totalNumInCorrect
      gon.totalCompiles = @totalCompiles
      gon.totalMarkedCompiles = @totalMarkedCompiles

      gon.totalRecall = @totalRecall
      gon.totalRecallWrong = @totalRecallWrong
    end

  end

  def manualCatTool
    @researcher = params[:researcher]
    @cyberdojo_id = params[:id]
    @cyberdojo_avatar = params[:avatar]
    @currSession = Session.where(cyberdojo_id: @cyberdojo_id, avatar: @cyberdojo_avatar).first  #.first
    gon.compiles = @currSession.compiles
    # gon.nextSession = Session.includes(:markups).where(:markups => { :session_id => nil }, ).first_compile_in_phase



    allMarkups = Hash.new
    @currSession.markups.each do |markup|

      if allMarkups.has_key?(markup.user)
        allMarkups[markup.user] << markup
      else
        currMarkup = Array.new
        currMarkup << markup
        allMarkups[markup.user] = currMarkup
      end
      puts "MARKUP"
      puts markup.user
      puts markup.inspect
    end

    gon.allMarkups = allMarkups

    gon.phases = Array.new
    gon.cyberdojo_id = @cyberdojo_id
    gon.cyberdojo_avatar = @cyberdojo_avatar
    gon.session_id = @currSession.id
    gon.researcher = @researcher

    #USE TO GRAB NEXT
    @researcher = params[:researcher]
    researcher_id = Researcher.find_by(name: @researcher).id
    all_sessions_markup = Array.new

    @inter_sessions = InterraterSession.all
    @inter_sessions.each do |interrater|
      session = Session.find_by(id: interrater.session_id)
      curr_session_markup = Hash.new
      curr_session_markup["interRater"] = true
      curr_session_markup["session"] = session
      curr_session_markup["markup"] = session.markups
      curr_session_markup["compile_count"] = Array.new.push(session.compiles.count)
      all_sessions_markup << curr_session_markup
    end

    @markup_sessions = MarkupAssignment.where(researcher_id: researcher_id)
    @markup_sessions.each do |assignment|
      session = Session.find_by(id: assignment.session_id)
      curr_session_markup = Hash.new
      curr_session_markup["interRater"] = false
      curr_session_markup["session"] = session
      curr_session_markup["markup"] = session.markups
      curr_session_markup["compile_count"] = Array.new.push(session.compiles.count)
      all_sessions_markup << curr_session_markup
    end

    gon.all_sessions_markup = all_sessions_markup
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


  def timelineWithBrush
    # Params to know what to draw
    @researcher = params[:researcher]
    @cyberdojo_id = params[:id]
    @cyberdojo_avatar = params[:avatar]
    @currSession = Session.where(cyberdojo_id: @cyberdojo_id, avatar: @cyberdojo_avatar).first  #.first
    gon.compiles = @currSession.compiles

    cycleArray = Array.new()
    allPhases  = Array.new()
    Cycle.where(session_id: @currSession.id).each do |cycle|
      currPhases = Array.new()
      Phase.where(cycle_id: cycle.id).each do |phase|
        phaseHash = Hash.new()
        phaseHash["color"] = phase.tdd_color
        compilesInPhase = Array.new
        puts "%%%%%%%%%%%%%%%%PHASE%%%%%%%%%%%%%%%%%%%"
        # puts compile.git_tag.to_s
        Compile.where(phase_id: phase.id).each do |compile|
          compilesInPhase << compile.git_tag
          puts "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
          puts compile.git_tag.to_s
        end
        phaseHash["compiles"] = compilesInPhase
        allPhases << phaseHash
        currPhases << phaseHash
      end
      currCompile = Hash.new()
      currCompile["valid_tdd"] = cycle.valid_tdd
      currCompile["all_phases"] = currPhases
      cycleArray << currCompile

    end

    gon.phases = allPhases
    gon.cyberdojo_id = @cyberdojo_id
    gon.cyberdojo_avatar = @cyberdojo_avatar
    gon.cycles = cycleArray

    # allCycles = Array.new
    # allPhases = Array.new
    # normalizedPhaseTime = Array.new
    # normalizedPhaseSLOC = Array.new
    # @currSession.cycles.each do |cycle|
    #   puts cycle.inspect
    #   currCycle = Hash.new
    #   currCycle[:valid_tdd] = cycle.valid_tdd
    #   # currCycle[:startCompile] = cycle.phases.first.compiles.first.git_tag
    #   # currCycle[:endCompile] = cycle.phases.last.compiles.last.git_tag
    #   allCycles << currCycle

    #   cycleStart = 0
    #   cycleEnd = 0
    #   puts cycle.phases.inspect
    #   totalCycleTime = 0
    #   totalCycleSloc = 0
    #   currPhaseTime = Hash.new
    #   currPhaseSloc = Hash.new
    #   cycle.phases.each do |phase|
    #     # phase.first_compile_in_phase = phase.compiles.first.git_tag
    #     # phase.last_compile_in_phase = phase.compiles.last.git_tag
    #     # print  "cycleStart:"
    #     # puts cycleStart
    #     # print  "cycleEnd:"
    #     # puts cycleEnd
    #     total_sloc_count = 0
    #     seconds_in_phase = 0
    #     phase.compiles.each do |compile|
    #       puts "compile.total_sloc_count: "+ compile.total_sloc_count.to_s
    #       puts "compile.seconds_since_last_light: "+ compile.seconds_since_last_light.to_s
    #       total_sloc_count = total_sloc_count + compile.total_sloc_count
    #       seconds_in_phase = seconds_in_phase + compile.seconds_since_last_light
    #     end
    #     puts "total_sloc_count: "+ total_sloc_count.to_s


    #     totalCycleSloc = totalCycleSloc + total_sloc_count
    #     totalCycleTime = totalCycleTime + seconds_in_phase
    #     phase.total_sloc_count = totalCycleSloc
    #     phase.seconds_in_phase = totalCycleTime
    #     phase.save
    #     allPhases << phase
    #   end
    #   cycle.phases.each do |phase|
    #     print "totalCycleSloc"
    #     puts totalCycleSloc
    #     print  "totalCycleTime"
    #     puts totalCycleTime
    #     currPhaseTime[phase.tdd_color] = phase.total_sloc_count.to_f/totalCycleSloc.to_f
    #     currPhaseSloc[phase.tdd_color] = phase.seconds_in_phase.to_f/totalCycleTime.to_f
    #     normalizedPhaseTime.push(currPhaseTime)
    #     normalizedPhaseSLOC.push(currPhaseSloc)
    #     print "currPhaseTime::"
    #     puts currPhaseTime.inspect
    #     print "currPhaseSloc::"
    #     puts currPhaseSloc.inspect
    #   end
    # end
    # puts allPhases.size
    # puts allPhases
    # gon.phases = allPhases
    # gon.cyberdojo_id = @cyberdojo_id
    # gon.cyberdojo_avatar = @cyberdojo_avatar
    # gon.normalizedPhaseTime = normalizedPhaseTime
    # gon.normalizedPhaseSLOC = normalizedPhaseSLOC
    # gon.cycles = allCycles

  end

  def retrieve_session
    start_id = params[:start]
    end_id = params[:end]
    cyberdojo_id = params[:cyberdojo_id]
    cyberdojo_avatar = params[:cyberdojo_avatar]
    print "Start:"
    print start_id
    print "  End:"
    puts end_id

    puts "*********************************"
    puts dojo.katas[cyberdojo_id].avatars[cyberdojo_avatar].lights.count
    if(dojo.katas[cyberdojo_id].avatars[cyberdojo_avatar].lights.count == end_id.to_i)
      end_id = end_id.to_i - 1
      puts end_id
    end

    # puts "@cyberdojo_id"
    @cyberdojo_id
    @cyberdojo_avatar
    # allFiles.push(dojo.katas['0A0D302A01'].avatars['cheetah'].lights[1].tag.visible_files)

    names = Hash.new
    names["start"] = dojo.katas[cyberdojo_id].avatars[cyberdojo_avatar].lights[start_id.to_i].tag.visible_files
    names["end"] = dojo.katas[cyberdojo_id].avatars[cyberdojo_avatar].lights[end_id.to_i].tag.visible_files

    names["start"].delete("output")
    names["end"].delete("output")
    names["start"].delete("instructions")
    names["end"].delete("instructions")
    names["start"].delete("cyber-dojo.sh")
    names["end"].delete("cyber-dojo.sh")
    puts names

    @oneSession = Session.all.first
    respond_to do |format|
      format.html
      # format.json { render :json => @oneSession }
      format.json { render :json => names }
    end
  end


  def store_markup
    puts params[:phaseData]
    puts params[:cyberdojo_id]
    puts params[:cyberdojo_avatar]
    this_phase_data = params[:phaseData]
    this_cyberdojo_id = params[:cyberdojo_id]
    this_cyberdojo_avatar = params[:cyberdojo_avatar]

    currSession = Session.where(cyberdojo_id: this_cyberdojo_id, avatar: this_cyberdojo_avatar).first

    markup = Markup.new
    markup.tdd_color = this_phase_data["color"]
    markup.first_compile_in_phase = this_phase_data["start"]
    markup.last_compile_in_phase = this_phase_data["end"]
    markup.session = currSession
    markup.user = params[:user]
    markup.cyberdojo_id = this_cyberdojo_id
    markup.avatar = this_cyberdojo_avatar
    markup.save

    names = Array.new
    respond_to do |format|
      format.html
      # format.json { render :json => @oneSession }
      format.json { render :json => names }
    end
  end

  def del_markup
    puts params[:phaseData]
    puts params[:cyberdojo_id]
    puts params[:cyberdojo_avatar]
    this_phase_data = params[:phaseData]
    this_cyberdojo_id = params[:cyberdojo_id]
    this_cyberdojo_avatar = params[:cyberdojo_avatar]

    currSession = Session.where(cyberdojo_id: this_cyberdojo_id, avatar: this_cyberdojo_avatar).first
    markup = Markup.find_by(session: currSession, user: params[:user], tdd_color: this_phase_data["color"],first_compile_in_phase: this_phase_data["start"], last_compile_in_phase: this_phase_data["end"])
    markup.destroy
    puts "MARKUP"
    puts markup.inspect

    names = Array.new
    respond_to do |format|
      format.html
      # format.json { render :json => @oneSession }
      format.json { render :json => names }
    end
  end

  def update_markup

    puts "%%%%%%%%%%%%%%%%%%update_markup$$$$$$$$$$$$$$$$$$"
    puts params[:phaseData]
    phaseData =  params[:phaseData]
    # phase
    puts phaseData[:oldStart]
    puts params[:cyberdojo_id]
    puts params[:cyberdojo_avatar]
    this_phase_data = params[:phaseData]
    this_cyberdojo_id = params[:cyberdojo_id]
    this_cyberdojo_avatar = params[:cyberdojo_avatar]

    currSession = Session.where(cyberdojo_id: this_cyberdojo_id, avatar: this_cyberdojo_avatar).first
    puts "currSession"
    puts currSession
    puts "params[:user]"
    puts params[:user]
    puts "this_phase_data[\"newColor\"]"
    puts this_phase_data["newColor"]
    puts "this_phase_data[\"oldStart\"]"
    puts this_phase_data["oldStart"]
    puts "this_phase_data[\"oldEnd\"]"
    puts this_phase_data["oldEnd"]
    markup = Markup.find_by(session: currSession.id, user: params[:user], first_compile_in_phase: this_phase_data["oldStart"], last_compile_in_phase: this_phase_data["oldEnd"])
    puts "MARKUP"
    puts markup.inspect
    # markup.destroy
    # markup.first_compile_in_phase = 10
    markup.first_compile_in_phase = this_phase_data["newStart"]
    markup.last_compile_in_phase = this_phase_data["newEnd"]
    markup.tdd_color = this_phase_data["newColor"]
    # markup.first_compile_in_phase = 99
    # markup.update_attribute(:first_compile_in_phase, 10)
    markup.save



    names = Array.new
    respond_to do |format|
      format.html
      # format.json { render :json => @oneSession }
      format.json { render :json => names }
    end
  end

  def markup_comparison

    @cyberdojo_id = params[:id]
    @cyberdojo_avatar = params[:avatar]
    @currSession = Session.where(cyberdojo_id: @cyberdojo_id, avatar: @cyberdojo_avatar).first  #.first
    gon.compiles = @currSession.compiles

    allPhases  = Array.new
    Cycle.where(session_id: @currSession.id).each do |cycle|
      Phase.where(cycle_id: cycle.id).each do |phase|
        phaseHash = Hash.new()
        phaseHash["color"] = phase.tdd_color
        compilesInPhase = Array.new
        puts "%%%%%%%%%%%%%%%%PHASE%%%%%%%%%%%%%%%%%%%"
        # puts compile.git_tag.to_s
        Compile.where(phase_id: phase.id).each do |compile|
          compilesInPhase << compile.git_tag
          puts "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
          puts compile.git_tag.to_s
        end
        phaseHash["compiles"] = compilesInPhase
        allPhases << phaseHash
      end
    end

    gon.phases = allPhases

    allMarkups = Hash.new
    @currSession.markups.each do |markup|

      if allMarkups.has_key?(markup.user)
        allMarkups[markup.user] << markup
      else
        currMarkup = Array.new
        currMarkup << markup
        allMarkups[markup.user] = currMarkup
      end
      # puts "MARKUP"
      # puts markup.user
      # puts markup.inspect
    end

    gon.allMarkups = allMarkups

    gon.cyberdojo_id = @cyberdojo_id
    gon.cyberdojo_avatar = @cyberdojo_avatar
  end

end
