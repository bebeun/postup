class Profile < ActiveRecord::Base

	belongs_to :profileable, polymorphic: true, class_name: "::Profile"
	#validates_inclusion_of :profileable_type, in: ["User","PotentialUser"]
		
	belongs_to :identable, polymorphic: true, class_name: "::Profile"
	#validates_inclusion_of :profileable_type, in: ["User","PotentialUser"]
	
	validates_uniqueness_of :profileable_id, :scope => [:identable_id, :identable_type,:profileable_type,],	:message => "Error on the join model. This association profileable/identable already exists"
	
	#attach the self profile to user. If profile was owned by a PotentialUser, the PotentialUser is destroyed
	def add_profile_to(user)
		user_destroy =  self.profileable
		user_actions_slaves = UserAction.where(supportable: user_destroy) 	#potential user supports/unsupports
		user_actions_masters = UserAction.where(supportable: user)			#target user supports/unsupports
		user_actions_slaves.each do |x|
			# the target user has supported/unsupported the profile is is trying to add to his profile
			# the target user and the profile is is trying to add to his profile are supported/unsupported by the same user. target user support/unsupport WINS !
			if x.user == user || user_actions_masters.collect{|y| y.user}.include?(x.user)
			# the support is destroy	
				x.destroy
			else
			# the owner support is changed
				x.update_attributes(supportable: user)
			end
		end
		user.profiles << self
		user_destroy.destroy! if user_destroy.class.name == "PotentialUser"
	end
end

