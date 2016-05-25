class Compile < ActiveRecord::Base
  belongs_to :phase
  belongs_to :session
end
