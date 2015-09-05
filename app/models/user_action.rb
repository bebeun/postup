class UserAction < ActiveRecord::Base
	belongs_to :creator, :class_name => "User", :foreign_key  => "user_id"
	validates :creator, presence: true
	
	belongs_to :supportable, polymorphic: true	
	validates :supportable, presence: true
	#belongs_to :user, :class_name => "User", :foreign_key => "supportable_id"
	#belongs_to :book, :class_name => "PotentialUser", :foreign_key => "supportable_id"
	
	validates :support, presence: true
	validates_inclusion_of :support, in: ["up","down"]
	
	validates_uniqueness_of :user_id, :scope => [:supportable_id, :supportable_type],	:message => "Error on the join model. This support already exists"

	validate :supporter_vs_supported
	def supporter_vs_supported
		if creator ==  supportable
			errors.add(:user, "You can t support or unsupport yourself") 
		end
	end
end
