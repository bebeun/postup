class ProfilesController < ApplicationController
	include ProfilesModule
	def attach_to_user
		profile = get_profile(profile_params[:global_id])	if !profile_params[:global_id].nil? 
		profile = description_by_display(profile_params[:display]) if !profile_params[:display].nil?
		
		if !profile.nil?
			profile.save! if profile.new_record? 
		else
			flash[:info] = " This is not a profile..." and redirect_to :back and return			
		end
		
		flash[:info] = " This is #{profile.owner.name} profile..." and redirect_to :back and return if profile.owner.class.name == "User"
		
		Profile::PROFILE_TYPES.each do |x|
			eval("redirect_to new_"+Profile::PROFILE_NAME_SINGULAR[x]+"_"+Profile::PROFILE_NAME_SINGULAR[x]+"_activation_path(profile) and return if profile.class.name == \""+x+"\"")
		end

	end
	
	
	def detach_from_user
		profile = get_profile(profile_params[:global_id])
		if !profile.nil?
			if Profile::PROFILE_ACTIVATION_TO_DESTROY[profile.class.name]
				eval(profile.class.name+"Activation.where("+Profile::PROFILE_NAME_SINGULAR[profile.class.name]+": profile, creator: current_user ).destroy_all")
			end
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
