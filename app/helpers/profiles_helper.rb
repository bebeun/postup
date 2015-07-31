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
				
		return nil if category.nil? || description.nil? 	#in this case, display doesnt match any identable type.
		
		identable = category.constantize.find_by_description(description)
		
		if !identable.nil? 									#identable and its profile already exist
			return identable.profile 
		else  												#one creates a new PotentialUser to attach it to this identable
			potential_user = PotentialUser.create()
			potential_user.profile = Profile.new()
			potential_user.profile.identable =  category.constantize.create(description: description)
			potential_user.save
			return potential_user.profile
		end
	end
end
