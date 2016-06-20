module GlobalIdModule
	def get_user_global_id(user)
		global_id = 2*user.id.to_i if user.class.name == "User" 
		global_id = 2*user.id.to_i+1 if user.class.name == "PotentialUser"  
		return global_id
	end
	
	def get_user(global_id)
		global_id = global_id.to_i
		user = User.find(global_id/2) if global_id % 2 == 0
		user = PotentialUser.find((global_id-1)/2) if global_id % 2 == 1
		return user
	end
	
	def get_profile_global_id(profile)
		global_id = Profile::PROFILE_TYPES.count*profile.id.to_i + Profile::PROFILE_TYPES.index(profile.class.name)
		return global_id
	end
	
	def get_profile(global_id)
		global_id = global_id.to_i
		classname = Profile::PROFILE_TYPES[global_id%Profile::PROFILE_TYPES.count]
		profile = classname.constantize.find((global_id-global_id%Profile::PROFILE_TYPES.count)/Profile::PROFILE_TYPES.count)
		return profile
	end
	
	def self.included m
		return unless m < ActionController::Base
		m.helper_method :get_user_global_id, :get_user, :get_profile_global_id, :get_profile
	end
end
