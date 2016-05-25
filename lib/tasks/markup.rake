# Selects Katas for Manual Markup
# Created: 12-17-14 by Hugh
#
# Notes: These commands will take time to execute based on total number of katas.
#        There is no overlap of assigned kata sessions between researchers
#        or between individual assignments and the interrater sessions.
#
# Usage:
#   bundle exec rake markup:assign_markup [KATAS=#]
#     Assigns random katas to each researcher with no overlap
#     May optionally specify # of Katas (do not include the square brackets)
#
#   bundle exec rake markup:pick_interrater [KATAS=#]
#     Assigns random katas for the interrater agreement
#     May optionally specify # of Katas (do not include the square brackets)
#
#   bundle exec rake markup:add_researcher NAME=name
#     Adds a new researcher with the name provided, if existing researchers
#     currently have assigned katas, the same number of katas will be assigned
#     to the new researcher.
#
DEFAULT_KATA_NUMBER = 50
DEFAULT_INTER_NUMBER = 50

def get_valid_sessions
  @sessions = Array.new
  all_sessions = Session.all
  #Limit sessions to desirable subset
  all_sessions.each do |session|
    if (session.language_framework == "Java-1.8_JUnit") && (session.compiles.count >= 2)
      @sessions.push(session)
    end
  end
end

def get_existing_session_assignments
  @existing_assignments = Array.new
  assignments = MarkupAssignment.all
  assignments.each do |assignment|
    @existing_assignments.push(assignment.session)
  end
  interraters = InterraterSession.all
  interraters.each do |interrater|
    @existing_assignments.push(interrater.session)
  end
end

def get_random_numbers(target_number)
  r = Random.new
  random_numbers = Array.new
  while target_number > 0
    number = r.rand(@sessions.count)
    unless ((@existing_assignments.include?(@sessions[number].id)) || (random_numbers.include?(number)))
      random_numbers.push(number)
      target_number = target_number - 1
    end
  end
  return random_numbers
end

def assign_markup(num_katas)
  researchers = Researcher.all
  random_sessions = get_random_numbers(researchers.count * num_katas)

  researchers.each do |researcher|
    for i in 1..num_katas
      assignment = MarkupAssignment.new
      assignment.researcher = researcher
      assignment.session = @sessions[random_sessions.pop]
      assignment.save
    end
  end
end

def pick_interrater(num_katas)
  random_sessions = get_random_numbers(num_katas)
  for i in 1..num_katas
    interrater = InterraterSession.new
    interrater.session = @sessions[random_sessions.pop]
    interrater.save
  end

end

def add_researcher(name)
  researchers = Researcher.all
  if researchers.count > 0
    num_katas = researchers[0].markup_assignments.count
  else
    num_katas = 0
  end

  researcher = Researcher.new
  researcher.name = name
  researcher.save

  if num_katas > 0
    get_valid_sessions
      get_existing_session_assignments
    random_sessions = get_random_numbers(num_katas)
    for i in 1..num_katas
      assignment = MarkupAssignment.new
      assignment.researcher = researcher
      assignment.session = @sessions[random_sessions.pop]
      assignment.save
    end
  end
end

namespace :markup do
  desc "Assigns random katas to each researcher with no overlap"
  task assign_markup: :environment do
    num_katas = ENV["KATAS"].to_i || DEFAULT_KATA_NUMBER
    get_valid_sessions
    get_existing_session_assignments
    assign_markup(num_katas)
  end

  desc "Assigns random katas for the interrater agreement"
  task pick_interrater: :environment do
    num_katas = ENV["KATAS"].to_i || DEFAULT_INTER_NUMBER
    get_valid_sessions
    get_existing_session_assignments
    pick_interrater(num_katas)
  end

  desc "Adds a new researcher with the name provided, if existing researchers currently have assigned katas, the same number of katas will be assigned to the new researcher."
  task add_researcher: :environment do
    name = ENV["NAME"]
    add_researcher(name)
  end
end
