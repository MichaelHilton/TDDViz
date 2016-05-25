# Mark katas as potentially completed
#
# Note: This design should allow for these rules to be tweaked,
#       and the rake task to be re-run
#
# Usage:
#   bundle exec rake find_potential_completed_katas
#

def find_potential_completed_katas

  Session.find_by_sql("SELECT * FROM sessions
WHERE language_framework LIKE \"Java-1.8_JUnit\"").each do |session|

    puts "(((((((((((((((((( New Session ))))))))))))))))))))"
    puts session.inspect
    puts " "
    puts " "
    session.potential_complete = false
    if session.final_light_color == "green"
      if session.total_sloc_count > 10
        session.potential_complete = true
      end
    end
    session.save
  end
end

task :find_potential_completed_katas do
  find_potential_completed_katas
end
