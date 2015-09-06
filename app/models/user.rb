class User < ActiveRecord::Base
	# DEVISE
	devise 	:database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
	validates :name, presence: true
	validates_uniqueness_of :name, :case_sensitive => false, :message => "This name has already been taken"
	
	# PROFILE Management
	has_many :twitters, as: :owner, class_name: "Twitter", dependent: :destroy
	has_many :facebooks, as: :owner, class_name: "Facebook", dependent: :destroy
	
	def profiles 
		return self.twitters + self.facebooks	
	end
	
	def add_profile(profile)
		self.twitters << profile if profile.class.name == "Twitter"
		self.facebooks << profile if profile.class.name == "Facebook"
	end
	
	# CALL Management
	has_many :call_actions
	has_many :callouts, through: :call_actions, source: "call", class_name: "Call"
	has_many :callins, as: :callable, class_name: "Call"

	# POST Management + POST S/U
	has_many :posts
	has_many :posts, inverse_of: :creator
	has_many :post_actions
	has_many :postsupports, through: :post_actions, source: "post", class_name: "Post"	
	
	# USER S/U
    has_many :user_actions
	has_many :user_supports, -> { where(user_actions: { support: 'up' }) }, through: :user_actions,  source: :supportable, source_type: 'User', dependent: :destroy
    has_many :potential_user_supports, -> { where(user_actions: { support: 'up' }) }, through: :user_actions,  source: :supportable, source_type: 'PotentialUser', dependent: :destroy
	has_many :user_unsupports, -> { where(user_actions: { support: 'down' }) }, through: :user_actions,  source: :supportable, source_type: 'User', dependent: :destroy
    has_many :potential_user_unsupports, -> { where(user_actions: { support: 'down' }) }, through: :user_actions,  source: :supportable, source_type: 'PotentialUser', dependent: :destroy
	has_many :user_actions_supporters, as: :supportable, :class_name => "UserAction"
	
	def supporters
		self.user_actions_supporters.select{|x| x.support == "up" }.collect{|x| x.creator}
	end
	
	def unsupporters
		self.user_actions_supporters.select{|x| x.support == "down"}.collect{|x| x.creator}
	end
	
	def supporting
		self.user_supports + self.potential_user_supports
	end

	def unsupporting
		self.user_unsupports + self.potential_user_unsupports
	end
	
	# FB Activations	
	has_many :facebook_activations
	
	# Functions
	def has_this_profile?(profile)
		self.profiles.include?(profile)
	end
	def has_this_facebook_activation?(facebook_activation)
		self.id == facebook_activation.creator.id
	end
	def has_pending_facebook_activations?(facebook)
		facebook.facebook_activations.collect{|fba| fba.creator}.include?(self)
	end
	def has_been_reported_for_facebook?(facebook)
		facebook.facebook_activations.select{|fba| fba.creator == self && fba.reported}.any?
	end
	def has_recent_facebook_activations?(facebook)
		facebook.facebook_activations.where("upadated_at > ?", 2.minutes.ago).collect{|fba| fba.creator}.include?(self)
	end
	def is_user?
		true
	end
	def is_potential_user?
		false
	end
	
	#DEVISE Soft Delete
	# instead of deleting, indicate the user requested a delete & timestamp it  
	def soft_delete  
		update_attribute(:deleted_at, Time.current)  
	end  

	# ensure user account is active  
	def active_for_authentication?  
		super && !deleted_at  
	end  

	# provide a custom message for a deleted account   
	def inactive_message   
		!deleted_at ? super : :deleted_account  
	end 
end	


