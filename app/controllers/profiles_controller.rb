class ProfilesController < ApplicationController
	def attach_to_user
		case
			when !profile_params[:id].nil? 
				profile = Profile.find(profile_params[:id])
			when !profile_params[:display].nil?
				search_key = description_by_display(profile_params[:display])
				if !search_key.nil? 
					identable = search_key["category"].constantize.find_by_description(search_key["description"])
					if(identable.nil?)
						profile = Profile.new()
						profile.identable = search_key["category"].constantize.new(description: search_key["description"]) 
					else
						profile = identable.profile
					end
				else
					#"==================> erreur car aucun profil reconnu dans ce display"
					# ??? .errors[:base] << "No Profil matches your input"
				end
		end
		if !profile.nil?
			user =  profile.profileable
			current_user.profiles << profile
			user.destroy! if user.class.name == "PotentialUser"
		end
		
		@profile = Profile.new()
		redirect_to edit_user_registration_path
	end
	
	
	def detach_from_user
		@profile = Profile.find(params[:id])
		@user = PotentialUser.new()
		current_user.profiles.delete(@profile)
		@user.profile = @profile
		@user.save
		redirect_to edit_user_registration_path
	end
	
	private
		def profile_params
    		params.require(:profile).permit(:id, :display)
		end
end
