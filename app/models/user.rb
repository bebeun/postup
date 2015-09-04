class User < ActiveRecord::Base
	# DEVISE
	devise 	:database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
	validates :name, presence: true
	validates_uniqueness_of :name, :case_sensitive => false, :message => "This name has already been taken"
	
	# PROFILE Management
	has_many :twitters, as: :owner, class_name: "Twitter"
	has_many :facebooks, as: :owner, class_name: "Facebook"
	
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
	has_many :user_supports, -> { where(user_actions: { support: 'up' }) }, through: :user_actions,  source: :supportable, source_type: 'User'
    has_many :potential_user_supports, -> { where(user_actions: { support: 'up' }) }, through: :user_actions,  source: :supportable, source_type: 'PotentialUser'
	has_many :user_unsupports, -> { where(user_actions: { support: 'down' }) }, through: :user_actions,  source: :supportable, source_type: 'User'
    has_many :potential_user_unsupports, -> { where(user_actions: { support: 'down' }) }, through: :user_actions,  source: :supportable, source_type: 'PotentialUser'
	has_many :user_actions_supporters, as: :supportable, :class_name => "UserAction"
	
	def supporters
		self.user_actions_supporters.select{|x| x.support == "up" }.collect{|x| x.user}
	end
	
	def unsupporters
		self.user_actions_supporters.select{|x| x.support == "down"}.collect{|x| x.user}
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
		self.id == facebook_activation.user.id
	end
	def has_pending_facebook_activations?(facebook)
		facebook.facebook_activations.collect{|fba| fba.user}.include?(self)
	end
	def has_been_reported_for_facebook?(facebook)
		facebook.facebook_activations.select{|fba| fba.user == self && fba.reported}.any?
	end
	def has_recent_facebook_activations?(facebook)
		facebook.facebook_activations.where("upadated_at > ?", 2.minutes.ago).collect{|fba| fba.user}.include?(self)
	end
	def is_user?
		true
	end
	def is_potential_user?
		false
	end
end	


#Before truc...check via regex description...
	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable and :omniauthable		
#Callout envoyé

=begin
	# inverse_of: :users ne marche pas avec through, polymorphic
	
	
	
There are a few limitations to inverse_of support:

    They do not work with :through associations.
    They do not work with :polymorphic associations.
    They do not work with :as associations.
    For belongs_to associations, has_many inverse associations are ignored.

Every association will attempt to automatically find the inverse association and set the :inverse_of option heuristically (based on the association name). Most associations with standard names will be supported. However, associations that contain the following options will not have their inverses set automatically:

    :conditions
    :through
    :polymorphic
    :foreign_key
=end
