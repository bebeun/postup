class ObjectAction < ActiveRecord::Base
	belongs_to :object, polymorphic: true
	validates :object, presence: true
  
  	belongs_to :creator, :class_name => "User"
	validates :creator, presence: true
	
	#S or U
	validates :status, presence: true
	validates_inclusion_of :status, in: ["active", "removed"]
	
	#S or U
	validates :support, presence: true
	validates_inclusion_of :support, in: ["up","down"]
	
	validates_uniqueness_of :creator_id, :scope => [:object_id, :object_type],	:message => "Error on the join model. You already S or U this object"	
end
