class CallAction < ActiveRecord::Base
	belongs_to :creator, :class_name => "User", :foreign_key  => "user_id"
	validates :creator, presence: true
	
	belongs_to :call
	validates :call, presence: true
	
	validates :support, presence: true
	validates_inclusion_of :support, in: ["up","down"]
	
	validates_uniqueness_of :user_id, :scope => [:call_id],	:message => "Error on the join model. This callout already exists"	
end
