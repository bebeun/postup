class CallAction < ActiveRecord::Base
	#USER who S/U this CALL
	belongs_to :creator, :class_name => "User", :foreign_key  => "user_id"
	validates :creator, presence: true
	
	#CALL it refers to
	belongs_to :call
	validates :call, presence: true
	
	#S or U
	validates :support, presence: true
	validates_inclusion_of :support, in: ["up","down"]
	
	validates_uniqueness_of :user_id, :scope => [:call_id],	:message => "Error on the join model. This callout already exists"	
	
	validate :callable_vs_supporters	
	def callable_vs_supporters
	if creator == call.callable 
			errors.add(:callable, "You can t support or unsupport your own callout") 
		end
	end
end
