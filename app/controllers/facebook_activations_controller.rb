class FacebookActivationsController < ApplicationController
	def new
		redirect_to root_path and return if(!user_signed_in?)
		@facebook = Facebook.find(params[:facebook_id])	
#========================SANITIZE debut===============================
		#on ne prend la main que sur un Facebook: qui ne nous appartient pas déjà, qui n appartient à aucun User, où il y a déjà une tentative de prise de contrôle récente par ce user.
		facebook_activation = FacebookActivation.where("created_at > ?", 2.minutes.ago).find_by(facebook: @facebook, user: current_user)
		if current_user.profiles.collect{|x| x.identable}.include?(@facebook) || @facebook.profile.profileable_type == "User" || !facebook_activation.nil?
			flash[:info] = "You can't do this"	
			redirect_to edit_user_registration_path(current_user)
		end
#========================SANITIZE fin===============================
	end

	def create
		facebook = Facebook.find(params[:facebook_id])	
		facebook_activation = FacebookActivation.new(facebook: facebook, user: current_user, token: SecureRandom.urlsafe_base64(64, false))	
#========================SANITIZE debut===============================
		#on ne prend la main que sur un Facebook: qui ne nous appartient pas déjà, qui n appartient à aucun User, 
		if current_user.profiles.collect{|x| x.identable}.include?(facebook) || facebook.profile.profileable_type == "User"
			flash[:info] = "You can t do this"	
			redirect_to edit_user_registration_path(current_user)
		end
#========================SANITIZE fin===============================
		if facebook_activation.save
			UserMailer.facebook_activation(facebook_activation, current_user).deliver_now
			flash[:info] = "Please check the Email attached to this Facebook profile"	
		else	
			flash[:info] = "You can't do this"	
		end
		redirect_to edit_user_registration_path(current_user)
	end
	
	def validate
		redirect_to root_path and return if(!user_signed_in?)
		facebook_activation = FacebookActivation.find_by(token: params["token"], facebook_id: params["facebook_id"], user_id: params["uid"] )
		#on vérifie que le current_user est bien celui qui a fait la demande, que il y a bien eu une demande de faite et qu elle n a pas déjà été validée.
		if current_user.id == facebook_activation.user.id && !facebook_activation.nil? &&  !facebook_activation.activated
			facebook_activation.update_attribute(:activated, true)
			facebook_activation.facebook.profile.add_profile_to(current_user)
			flash[:info] = "The Facebook profil: www.facebook.com/"+facebook_activation.facebook.description+" is now yours!!!"			
		else
			flash[:info] = "There is a problem" 
		end
		redirect_to edit_user_registration_path(current_user) 
	end
	

end
