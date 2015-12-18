module CallsHelper
	def callable_user(conversation, current_user)
		callable_users = User.all - [current_user]
		if !conversation.nil?
			callable_users -= conversation.calls.where(callable_type: "User")\
			.select { |call| ((call.supporters.include?(current_user) || call.unsupporters.include?(current_user)) && call.status == "active" && !call.declined) }\
			.collect{|call| call.callable }
		end
		
		callable_potential_users = PotentialUser.all
		if !conversation.nil?
			callable_potential_users -= conversation.calls.where(callable_type: "PotentialUser")\
			.select { |call| (call.supporters.include?(current_user) || call.unsupporters.include?(current_user)) }\
			.collect{|call| call.callable } 
		end
		
		return options_for_select(callable_users.collect{|p| [ "USER : "+p.name+" : "+p.profiles.collect{|x| Profile::PROFILE_SYMBOL[x.class.name]+" "+x.description }.join(", "), get_user_global_id(p) ]} + \
		callable_potential_users.to_a.collect{|p| [ "POTENTIAL USER : "+Profile::PROFILE_SYMBOL[p.profile.class.name]+" : "+p.profile.description, get_user_global_id(p) ]})
	end
end

