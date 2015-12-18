module ProfilesHelper
	def available_profiles(current_user)
		return PotentialUser.all.collect{|p| p.profile}. \
		select{|p| p.is_available_for(current_user)}.  \
		collect{|p| [Profile::PROFILE_SYMBOL[p.class.name]+" : "+p.description, get_profile_global_id(p) ]} 
	end
end
