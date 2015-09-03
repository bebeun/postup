class UserAction < ActiveRecord::Base
	belongs_to :user #creator, :class_name => "User", :foreign_key  => "creator_id"
	
	belongs_to :supportable, polymorphic: true
	#belongs_to :user, :class_name => "User", :foreign_key => "supportable_id"
	#belongs_to :book, :class_name => "PotentialUser", :foreign_key => "supportable_id"
	
	validates :user, presence: true	
	validates :supportable, presence: true
	
	validates_uniqueness_of :user_id, :scope => [:supportable_id, :supportable_type],	:message => "Error on the join model. This support already exists"

	validates :support, presence: true
	validates_inclusion_of :support, in: ["up","down"]
		
	validate :supporter_vs_supported
	def supporter_vs_supported
		if user ==  supportable
			errors.add(:user, "You can t support or unsupport yourself") 
		end
	end
end
