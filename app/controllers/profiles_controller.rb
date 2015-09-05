class ProfilesController < ApplicationController

	def attach_to_user
		case
			when !profile_params[:global_id].nil? 
				profile = get_profile(profile_params[:global_id])	
			when !profile_params[:display].nil?
				profile = description_by_display(profile_params[:display])
		end
		if !profile.nil?  &&  profile.class.name == "Facebook"
			redirect_to new_facebook_facebook_activation_path(profile) and return
		end

		if !profile.nil? 						#dirty - waiting for omniauth redirect strategy
			num = profile.owner.id
			add_profile_to(current_user, profile) 
			@profile = Profile.new()
		else
			flash[:info] = " This is not a profile..."
		end
	
		(request.env["HTTP_REFERER"].include?("potential_users/"+num.to_s)) ? (redirect_to edit_user_registration_path) : (redirect_to :back)  		#dirty - waiting for omniauth redirect strategy
	end
	
	
	def detach_from_user
		profile = get_profile(profile_params[:global_id])
		if !profile.nil?  &&  profile.class.name == "Facebook"
			facebook_activation = FacebookActivation.find_by(facebook: profile, creator: current_user )
			facebook_activation.destroy if !facebook_activation.nil?
		end
		profile.owner = PotentialUser.new()
		profile.save
		redirect_to :back
	end
	
	private
		def profile_params
    		params.require(:profile).permit(:global_id, :display)
		end
end
