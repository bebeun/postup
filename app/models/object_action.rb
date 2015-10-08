class ObjectAction < ActiveRecord::Base
	before_save :check_anteriority
	def check_anteriority
		self.to_be_checked.each do |x|
			aftf_action = ObjectAction.find_by(creator: self.creator, object: x, relevant: true)
			aftf_action.update_attributes(relevant: false) if !aftf_action.nil?
		end
	end
	
	before_destroy :renew_anteriority
	def renew_anteriority
		if !self.to_be_checked.empty?
			aftf_action = ObjectAction.find_by(creator: self.creator, object: self.to_be_checked.first, relevant: false)
			aftf_action.update_attributes(relevant: true) if !aftf_action.nil?
		end
	end
	
	def to_be_checked
		return_collection = []
		return_collection = [self.object.authorised_aftf] if self.object_type == "Call" && !self.object.authorised_aftf.nil?
		return_collection = [self.object.parent] if self.object_type == "Post" && self.object.parent_type == "Call"  && self.object.parent.authorised_aftf.nil? 
		return_collection = [self.object.parent, self.object.parent.authorised_aftf] if self.object_type == "Post" && self.object.parent_type == "Call" && !self.object.parent.authorised_aftf.nil? 
		return return_collection
	end
	
	belongs_to :object, polymorphic: true
	validates :object, presence: true
  
  	belongs_to :creator, :class_name => "User"
	validates :creator, presence: true
	
	#S or U
	validates :support, presence: true
	validates_inclusion_of :support, in: ["up","down"]
	
	validates_uniqueness_of :creator_id, :scope => [:object_id, :object_type],	:message => "Error on the join model. You already S or U this object"	
end
