module ProfilesHelper
	def description_by_display(display)
		case
			when display.include?("facebook.com")
				category = "Facebook"
				description = display.split('facebook.com')[1].split('/')[1]
			when display.include?("twitter.com")
				category = "Twitter"
				description = display.split('twitter.com')[1].split('/')[1]
		end
		return nil if category.nil? || description.nil? 	#in this case, display doesnt match any profile type.
		profile = category.constantize.find_by_description(description)
		if profile.nil? 							
			profile = category.constantize.new(description: description)
			profile.owner = PotentialUser.new()
			profile.save
		end
		return profile
	end
	

	def add_profile_to(creator, profile)
		user_destroy =  profile.owner
		user_actions_slaves = UserAction.where(supportable: user_destroy) 	
		user_actions_masters = UserAction.where(supportable: creator)			
		user_actions_slaves.each do |x|
			if x.creator == creator || user_actions_masters.collect{|y| y.creator}.include?(x.creator)
				x.destroy
			else
				x.update_attributes(supportable: creator)
			end
		end
		creator.add_profile(profile)
		user_destroy.destroy! if user_destroy.class.name == "PotentialUser"
	end
	
	def get_profile_global_id(profile)
		global_id = 2*profile.id.to_i if profile.class.name == "Twitter" 
		global_id = 2*profile.id.to_i+1 if profile.class.name == "Facebook"  
		return global_id
	end
	
	def get_profile(global_id)
		global_id = global_id.to_i
		profile = Twitter.find(global_id/2) if global_id % 2 == 0
		profile = Facebook.find((global_id-1)/2) if global_id % 2 == 1
		return profile
	end
end
