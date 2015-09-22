class PotentialUser < ActiveRecord::Base
	#CALL to this POTENTIAL USER
	has_many :callins, as: :callable, class_name: "Call"
	
	#PROFILE owned by this POTENTIAL USER (only one!)
	Profile::PROFILE_TYPES.each do |x|
		eval("has_one :"+Profile::PROFILE_NAME_SINGULAR[x]+", as: :owner, class_name: "+x)
	end
	
	def profile
		Profile::PROFILE_TYPES.each do |x|
			eval("return self."+Profile::PROFILE_NAME_SINGULAR[x]+" if self."+Profile::PROFILE_NAME_SINGULAR[x])
		end
	end
	
	def can_post?(conversation)
		return !self.parent_call(conversation).nil?													#self is called out
	end
	
	def parent_call(conversation)
		#===========================================>(last is DIRTY - index on updated_at ??)	
		parent = nil
		parent = Call.where(conversation: conversation, callable: self).last if Call.where(conversation: conversation, callable: self).any?
		return parent
	end
	
	# def profile=(profile)
		# profile.update_attributes(owner: self)
	# end
	
	# validate :one_profile
	# def one_profile
		# errors.add(:user, "There must be one and only one profile") if profile.nil? 
	# end
	
	#S/U
	has_many :user_actions_supporters, as: :supportable, :class_name => "UserAction"
	def supporters
		self.user_actions_supporters.select{|x| x.support == "up"}.collect{|x| x.creator}
	end
	def unsupporters
		self.user_actions_supporters.select{|x| x.support == "down"}.collect{|x| x.creator}
	end
	def is_potential_user?
		true
	end
	def is_user?
		false
	end
	
end

