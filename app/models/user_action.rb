class UserAction < ActiveRecord::Base
	#USER who S/U
	belongs_to :creator, :class_name => "User", :foreign_key  => "user_id"
	validates :creator, presence: true
	
	#USER or POTENTIAL USER target of this S/U
	belongs_to :supportable, polymorphic: true	
	validates :supportable, presence: true
	
	#S or U ?
	validates :support, presence: true
	validates_inclusion_of :support, in: ["up","down"]
	
	#
	validates_uniqueness_of :user_id, :scope => [:supportable_id, :supportable_type],	:message => "Error on the join model. This support already exists"
	
	#
	validate :supporter_vs_supported
	def supporter_vs_supported
		if creator ==  supportable
			errors.add(:user, "You can t support or unsupport yourself") 
		end
	end
end
