class ProfilesController < ApplicationController
	def attach_to_user
		case
			when !profile_params[:id].nil? 
				profile = Profile.find(profile_params[:id])
			when !profile_params[:display].nil?
				profile = description_by_display(profile_params[:display])
		end
		if !profile.nil?  &&  profile.identable_type == "Facebook"
			redirect_to new_facebook_facebook_activation_path(profile.identable) and return
		end
		profile.add_profile_to(current_user) if !profile.nil? 
		@profile = Profile.new()
		redirect_to :back
		
	end
	
	
	def detach_from_user
		profile = Profile.find(params[:id])
		if !profile.nil?  &&  profile.identable_type == "Facebook"
			facebook_activation = FacebookActivation.find_by(facebook: profile.identable, user: current_user )
			facebook_activation.destroy if !facebook_activation.nil?
		end
		user = PotentialUser.new()
		current_user.profiles.delete(profile)
		user.profile = profile
		user.save
		redirect_to :back
	end
	
	private
		def profile_params
    		params.require(:profile).permit(:id, :display)
		end
end
