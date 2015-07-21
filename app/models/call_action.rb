class CallAction < ActiveRecord::Base
	belongs_to :user
	belongs_to :call
	validates_uniqueness_of :user_id, :scope => [:call_id],	:message => "..."
end
