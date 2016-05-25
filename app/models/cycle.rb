class Cycle < ActiveRecord::Base
  belongs_to :session
  has_many :phases
  #has_many :compiles, :through => :phases
end
