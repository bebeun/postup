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
		parent = parent_call(conversation)													#self is called out
		if !parent.nil?
			answered = parent.child_post.nil?													#he has not yet posted
			child_answered = !parent.child_calls.any?											#and has not yet called
			return answered && child_answered
		else
			return false
		end
	end
	
	def can_call?(conversation)
		parent = parent_call(conversation)													#self is called out
		if !parent.nil?
			#===> parent.child_post. moins de 1h ??
			#===> bouton pour dire "je ne fwd pas ?"
			answered = !parent.child_post.nil?													#he has posted
			child_answered = !parent.child_calls.collect{|x| x.child_post}.any?					#and none of his calls have been yet answered by posting
			forwarded = !parent.child_calls.collect{|x| x.child_calls}.flatten.any?				#and none of his calls have been forwarded 
			return answered && child_answered && forwarded
		else
			return false
		end
	end
	
	def can_aftf?(conversation)
		cond = !can_post?(conversation) && !can_call?(conversation) 											#can't do anything
		cond &&= !conversation.aftfs.select{|x| x.alive? && x.creator == self}.any?								#has not an aftf alive (not answered)
		action = conversation.aftfs.last(Aftf::MAX_AFTF_PER_CONV).select{|x| !x.accepted && x.creator == self}	#has not been refused the floor more than 3 times in a row
		cond &&= (action.count != Aftf::MAX_AFTF_PER_CONV)														#Max number of AFTF in a conv
		return cond
	end
	
	def parent_call(conversation)
		#===========================================>(last is DIRTY - index on updated_at ??)	
		parent = nil
		parent = conversation if conversation.creator == self
		parent = Call.where(conversation: conversation, callable: self).last if Call.where(conversation: conversation, callable: self).any?
		return parent
	end
	
	#if call has given a post or child calls, the s/u have been switched to the post. the call can't be s/u anymore
	def can_s_call?(call)
		return call.creator != self && call.child_post.nil? && call.callable != self && !call.child_calls.any? && !call.supporters.include?(self)#==============>garder le !call.child_calls.any?
	end
	def can_u_call?(call)
		return call.creator != self && call.child_post.nil? && call.callable != self && !call.child_calls.any? && !call.unsupporters.include?(self)#==============>garder le !call.child_calls.any?
	end
	def can_remove_s_or_u_call?(call)
		return call.creator != self && call.child_post.nil? && call.callable != self && !call.child_calls.any? && (call.supporters.include?(self) || call.unsupporters.include?(self))#==============>garder le !call.child_calls.any?
	end
	def can_destroy_call?(call)
		return call.creator == self && call.child_post.nil? && !call.child_calls.any? 
	end

	def can_s_aftf?(aftf)
		return aftf.creator != self && aftf.alive? && !aftf.supporters.include?(self) # && !can_call?(aftf.conversation)
	end
	
	def can_u_aftf?(aftf)
		return aftf.creator != self && aftf.alive? && !aftf.unsupporters.include?(self) # && !can_call?(aftf.conversation)
	end
	
	def can_remove_s_or_u_aftf?(aftf)
		return aftf.creator != self && (aftf.supporters.include?(self) || aftf.unsupporters.include?(self)) && aftf.alive? 
	end
		
	def can_accept_aftf?(aftf)
		can_call?(aftf.conversation) && aftf.alive?
	end
	def can_disrefuse_aftf?(aftf) 
		!aftf.alive? && !aftf.accepted && aftf.decider == self && !aftf.conversation.aftfs.select{|x| x.creator == aftf.creator  && (x.created_at > aftf.created_at)}.any? 
	end
	
	def can_disaccept_aftf?(aftf) 
		if aftf.brother_call.nil?
			return false 
		else
			return !aftf.alive? && aftf.accepted && aftf.decider == self && aftf.brother_call.child_post.nil? && !aftf.brother_call.child_calls.any?
		end
	end

	
	def can_destroy_post?(post)
		return !post.brother_calls.any? && post.creator == self     #idealement forwarded AND answered
	end
	
	def can_edit_post?(post)
		return !post.brother_calls.any? && post.creator == self && post.visible     #idealement forwarded AND answered
	end
	
	def can_s_post?(post)
		return post.creator != self && !post.supporters.include?(self)
	end
	def can_u_post?(post)
		return post.creator != self && !post.unsupporters.include?(self)
	end
	def can_remove_s_or_u_post?(post)
		return post.creator != self && (post.supporters.include?(self) || post.unsupporters.include?(self))
	end
	
	def supports(object)
		object.unsupporters.destroy(self) if object.unsupporters.include?(self)
		object.supporters << self if !object.supporters.include?(self) 
	end
	
	def unsupports(object)
		object.supporters.destroy(self) if object.supporters.include?(self)
		object.unsupporters << self if !object.unsupporters.include?(self) 
	end
	
	def remove(object)
		object.supporters.destroy(self) if object.supporters.include?(self)
		object.unsupporters.destroy(self) if object.unsupporters.include?(self)
	end

	#post has a parent. this parent has child_calls. 
	#if one can't edit or destroy, the post can be made not visible
	def can_hide?(post)
		return post.brother_calls.any? && post.creator == self && post.visible
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
	has_many :object_actions, inverse_of: :creator
	#has_many :callouts, through: :object_actions, source: :object, source_type: 'Call', foreign_key: "object_id"
	def callouts
		return Call.select{|x| x.creator == self}
	end
	has_many :callins, as: :callable, class_name: "Call"

	# POST Management + POST S/U
	# has_many :posts, inverse_of: :creator
	has_many :postsupports, through: :object_actions, source: :object, source_type: "Post"
	
	#AFTF Management + ASTF S/USER
	has_many :aftfs, inverse_of: :creator, foreign_key: "creator_id"
	has_many :aftfsupports, through: :object_actions, source: :object, source_type: "Aftf"
	
	
	# USER S/U
    has_many :user_actions
	has_many :user_supports, -> { where(user_actions: { support: 'up' }) }, through: :user_actions,  source: :supportable, source_type: 'User', dependent: :destroy
    has_many :potential_user_supports, -> { where(user_actions: { support: 'up' }) }, through: :user_actions,  source: :supportable, source_type: 'PotentialUser', dependent: :destroy
	has_many :user_unsupports, -> { where(user_actions: { support: 'down' }) }, through: :user_actions,  source: :supportable, source_type: 'User', dependent: :destroy
    has_many :potential_user_unsupports, -> { where(user_actions: { support: 'down' }) }, through: :user_actions,  source: :supportable, source_type: 'PotentialUser', dependent: :destroy
	has_many :user_actions_supporters, as: :supportable, :class_name => "UserAction"
	
	def supporters
		user_actions_supporters.select{|x| x.support == "up" }.collect{|x| x.creator}
	end
	
	def unsupporters
		user_actions_supporters.select{|x| x.support == "down"}.collect{|x| x.creator}
	end
	
	def supporting
		user_supports + potential_user_supports
	end

	def unsupporting
		user_unsupports + potential_user_unsupports
	end
	
	# FB Activations	
	# MAKE MORE GENERAL
	has_many :facebook_activations
	
	# Functions
	def has_this_profile?(profile)
		profiles.include?(profile)
	end
	def has_this_facebook_activation?(facebook_activation)
		id == facebook_activation.creator.id
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


