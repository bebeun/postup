module CallsHelper
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
end
