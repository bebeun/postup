class ProfilesController < ApplicationController

	def attach_to_user
		profile = get_profile(profile_params[:global_id])	if !profile_params[:global_id].nil? 
		profile = description_by_display(profile_params[:display]) if !profile_params[:display].nil?
		
		profile.save! if profile.new_record? if !profile.nil?
		
		redirect_to new_facebook_facebook_activation_path(profile) and return if profile.class.name == "Facebook"
		redirect_to new_twitter_twitter_activation_path(profile) and return if profile.class.name == "Twitter"
		
		if profile.nil?
			flash[:info] = " This is not a profile..."
			redirect_to :back	
		end
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
