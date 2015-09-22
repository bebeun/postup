class User < ActiveRecord::Base
	# DEVISE
	devise 	:database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
	validates :name, presence: true
	validates_uniqueness_of :name, :case_sensitive => false, :message => "This name has already been taken"
	
	# PROFILE Management	
	Profile::PROFILE_TYPES.each do |x|
		eval("has_many :"+Profile::PROFILE_NAME_PLURAL[x]+", as: :owner, class_name: "+x)
	end
	
	def profiles 
		code_string = Profile::PROFILE_TYPES.collect{|x| "self."+Profile::PROFILE_NAME_PLURAL[x]}
		code_string = code_string.join(" + ")
		return eval(code_string)
	end
	
	def add_profile(profile)
		profile.update_attributes(owner: self)
	end
	
	def can_post?(conversation)
		parent = self.parent_call(conversation)													#self is called out
		if !parent.nil?
			answered = parent.child_post.nil?													#he has not yet posted
			child_answered = !parent.child_calls.collect{|x| x.child_post}.any?					#and none of his calls have been yet answered by posting
			forwarded = !parent.child_calls.collect{|x| x.child_calls}.flatten.any?   			#and none of his calls have been forwarded 
			return answered && child_answered && forwarded
		else
			return false
		end
	end
	
	def can_call?(conversation)
		parent = self.parent_call(conversation)													#self is called out
		if !parent.nil?
			child_answered = !parent.child_calls.collect{|x| x.child_post}.any?					#and none of his calls have been yet answered by posting
			forwarded = !parent.child_calls.collect{|x| x.child_calls}.flatten.any?				#and none of his calls have been forwarded 
			return child_answered && forwarded
		else
			return false
		end
	end
	
	def can_aftf?(conversation)
		cond = !can_post?(conversation) && !can_call?(conversation) 											#can't do anything
		cond &&= !conversation.aftfs.select{|x| x.alive? && x.creator == self}.any?								#has not an aftf alive (not answered)
		action = conversation.aftfs.last(Aftf::MAX_AFTF_PER_CONV).select{|x| !x.accepted && x.creator == self}	#has not been refused the floor more than 3 times in a row
		cond &&= (action.count != Aftf::MAX_AFTF_PER_CONV)	#Max number of AFTF in a conv
		return cond
	end
	
	def parent_call(conversation)
		#===========================================>(last is DIRTY - index on updated_at ??)	
		parent = nil
		parent = conversation if conversation.creator == self
		parent = Call.where(conversation: conversation, callable: self).last if Call.where(conversation: conversation, callable: self).any?
		return parent
	end
	
	#if call has given a post, the s/u have been switched to the post. the call can't be s/u anymore
	def can_s_or_u_call?(call)
		return call.child_post.nil? && call.callable != self
	end

	#if call has given a post, the s/u have been switched to the post. the call can't be s/u anymore
	def can_s_or_u_aftf?(aftf)
		return aftf.creator != self && aftf.alive?
	end
	
	#Critical situation: a call has given children ( child_calls, child_post )
	#one shouldn't unsupport (which could lead to destroy it) or destroy it
	#(in fact, to check for child_post is redundant with "can_be_s_or_u?")
	#keep the TREE RELEVANT and VALID
	def can_not_unsupport_or_destroy?(call)
		return call.supporters.count == 1 && call.supporters.include?(self) && (call.child_calls.any? || !call.child_post.nil?)
	end
	
	#post has a parent. this parent has child_calls. 
	#if they are either answered or forwarded, edition/destruction of post is not allowed.
	def can_edit_or_destroy?(post)
		return !post.parent.child_calls.collect{|x| x.child_post}.any? && !post.parent.child_calls.collect{|x| x.child_calls}.flatten.any? && post.creator == self
	end
	
	def displayable_user(conversation)
		users = User.all - [self]
		if !conversation.nil?
			users -= conversation.calls.where(callable_type: "User")\
			.select { |call| (call.supporters.include?(self) || call.unsupporters.include?(self))}\
			.select { |call| call.callable.can_post?(conversation) || call.callable.can_call?(conversation)}\
			.collect{|call| call.callable }
		end
		return users
	end
	
	def displayable_potential_user(conversation)
		potential_users = PotentialUser.all
		if !conversation.nil?
			potential_users -= conversation.calls.where(callable_type: "PotentialUser")\
			.select { |call| (call.supporters.include?(self) || call.unsupporters.include?(self)) }\
			.collect{|call| call.callable } 
		end
		return potential_users
	end
	
	# CALL Management
	#CALL S/U
	has_many :call_actions
	has_many :callouts, through: :call_actions, source: "call", class_name: "Call"
	has_many :callins, as: :callable, class_name: "Call"
	#CALL creation
	has_many :created_callouts, class_name: "Call", :foreign_key  => "creator_id"

	# POST Management + POST S/U
	has_many :posts
	has_many :posts, inverse_of: :creator
	has_many :post_actions
	has_many :postsupports, through: :post_actions, source: "post", class_name: "Post"	
	
	#AFTF Management + ASTF S/USER
	has_many :aftfs
	
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
	# MAKE MORE GENERAL
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


