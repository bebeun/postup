class FacebookActivationsController < ApplicationController
	def new
		redirect_to root_path and return if(!user_signed_in?)#return root for not logged users
		@facebook = Facebook.find(params[:facebook_id])	
		
		cond1 = @facebook.nil?												#refuse access to new fba page if facebook doesn't exist
		cond2 = current_user.has_pending_facebook_activations?(@facebook)	#refuse access to new fba page if user already asked for this facebook
		cond3 = current_user.has_this_identable?(@facebook)					#refuse access to new fba page if user already owns this facebook
		cond4 = @facebook.profile.profileable.is_user?						#refuse access to new fba page if this facebook is already owned by a User

		redirect_to edit_user_registration_path(current_user) and return if cond1 || cond2 || cond3 || cond4
		@facebook_activation = FacebookActivation.new()
	end

	def create		
		redirect_to root_path and return if(!user_signed_in?)
		facebook = Facebook.find(params[:facebook_id])
		
		cond1 = facebook.nil?												#refuse to create fba if facebook doesn't exist
		cond2 = current_user.has_pending_facebook_activations?(facebook)	#refuse to create fba if user already asked for this facebook
		cond3 = current_user.has_this_identable?(facebook)					#refuse to create fba if user already owns this facebook
		cond4 = facebook.profile.profileable.is_user?						#refuse to create fba if this facebook is already owned by a User

		if cond1 || cond2 || cond3 || cond4
			flash[:info] = "You can t do this"	
		else
			facebook_activation = FacebookActivation.create(facebook: facebook, user: current_user, token: SecureRandom.urlsafe_base64(64, false))	
			UserMailer.facebook_activation(facebook_activation, current_user).deliver_now
			flash[:info] = "Please check the Email attached to this Facebook profile"	
		end
		redirect_to edit_user_registration_path(current_user)	
	end
	
	def resend
		redirect_to root_path and return if(!user_signed_in?)
		facebook_activation = FacebookActivation.find_by(params[:id])
		
		cond1 = facebook_activation.nil?   												#if the activation was never created
		cond2 = !current_user.has_this_facebook_activation?(facebook_activation)		#or was created by another user (not current_user)
		cond3 = facebook_activation.activated											#or is already activated
		
		if cond1 || cond2 || cond3 
			flash[:info] = "There is a problem" 
		else
			facebook_activation.touch	
			UserMailer.facebook_activation(facebook_activation, current_user).deliver_now
			flash[:info] = "Please check the Email attached to this Facebook profile"
		end
		redirect_to edit_user_registration_path(current_user)	
	end
	
	
	def validate
		redirect_to root_path and return if(!user_signed_in?)	 #friendly redirect	
		facebook_activation = FacebookActivation.find_by(token: params["token"], facebook_id: params["facebook_id"], user_id: params["uid"] )
	
		cond1 = facebook_activation.nil?   												#if the activation was never created
		cond2 = !current_user.has_this_facebook_activation?(facebook_activation)		#or was created by another user (not current_user)
		cond3 = facebook_activation.activated											#or is already activated
		
		if cond1 || cond2 || cond3 
			flash[:info] = "There is a problem" 
		else
			flash[:info] = "The Facebook profil: www.facebook.com/"+facebook_activation.facebook.description+" is now yours!!!"	
			facebook_activation.update_attribute(:activated, true)
			facebook_activation.facebook.profile.add_profile_to(current_user)
		end
		redirect_to edit_user_registration_path(current_user) 
	end
	
	def cancel
		redirect_to root_path and return if(!user_signed_in?)
		facebook_activation = FacebookActivation.find_by(params[:id])
		
		cond1 = facebook_activation.nil?   												#if the activation was never created
		cond2 = !current_user.has_this_facebook_activation?(facebook_activation)		#or was created by another user (not current_user)
		cond3 = facebook_activation.activated											#or is already activated
		
		puts "cond1 =>>>>>>>>>>"+cond1.to_s
		puts "cond2 =>>>>>>>>>>"+cond2.to_s
		puts "cond3 =>>>>>>>>>>"+cond3.to_s
		
		if cond1 || cond2 || cond3 
			flash[:info] = "There is a problem" 
		else
			facebook_activation.destroy
			flash[:info] = "Facebook Activation cancelled"
		end
		redirect_to edit_user_registration_path(current_user)	
	end
	
#detach from user ==============> destroy fba associé
end