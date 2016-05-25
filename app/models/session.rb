class Session < ActiveRecord::Base
  has_many :cycles
  # has_many :phases, :through => :cycles
  #has_many :compiles, :through => :phases
  has_many :compiles
  has_many :markups
  has_one :markup_assignment
  has_one :interrater_session
  has_many :ast_trees
end
