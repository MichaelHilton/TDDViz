root = '../..'

require_relative root + '/config/environment.rb'
require_relative root + '/lib/Docker'
require_relative root + '/lib/DockerTestRunner'
require_relative root + '/lib/DummyTestRunner'
require_relative root + '/lib/Folders'
require_relative root + '/lib/Git'
require_relative root + '/lib/HostTestRunner'
require_relative root + '/lib/OsDisk'

class CompletedController < ApplicationController

  skip_before_filter  :verify_authenticity_token

  def index
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

  def mark_completed
    @session_ids = Array.new
    @kata = params[:kata]
    allSessions = Session.where(language_framework: "Java-1.8_JUnit", kata_name: @kata, potential_complete: true)
    gon.allSessions = allSessions

    allSessions.each do |key, array|
      @session_ids.push(key)
    end
    gon.session_ids = @session_ids

  end

  def mark_kata
    # Get this particular session
    id = params[:id]
    session = Session.where(id: id).first

    # Find id of next session
    kata = params[:kata]
    puts kata
    all_session_ids = Array.new
    all_sessions = Session.where(language_framework: "Java-1.8_JUnit", kata_name: kata, potential_complete: true)
    all_sessions.each do |key, array|
      all_session_ids.push(key.id)
    end
    next_id = all_session_ids.index(id.to_i) + 1
    if not next_id.nil?
      gon.next_id = all_session_ids.at(next_id)
    end

    allFiles = dojo.katas[session.cyberdojo_id].avatars[session.avatar].lights[session.total_light_count.to_i-1].tag.visible_files

    gon.allFiles = allFiles
    gon.is_complete = session.is_complete

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
    if params[:complete] == ""
      currSession.is_complete = ""
    end

    currSession.save

    names = Array.new
    respond_to do |format|
      format.html
      # format.json { render :json => @oneSession }
      format.json { render :json => names }
    end
  end
end
