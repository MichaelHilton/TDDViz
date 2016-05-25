class MarkupAssignment < ActiveRecord::Base
	belongs_to :researcher
	belongs_to :session
end