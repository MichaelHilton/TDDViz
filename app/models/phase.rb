class Phase < ActiveRecord::Base
  belongs_to :cycle
  has_many :compiles
end
