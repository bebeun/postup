class AftfAction < ActiveRecord::Base
	belongs_to :creator, class_name: "User"
	validates :creator, presence: true	
  
	belongs_to :aftf
	validates :aftf, presence: true	
	
	validates :support, presence: true
	validates_inclusion_of :support, in: ["up","down"]
	
	validates_uniqueness_of :creator_id, :scope => [:aftf_id],	:message => "Error on the join model. You already s/u this aftf	"	
end
