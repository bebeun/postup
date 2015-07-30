class FacebookActivationsController < ApplicationController
	def new
		redirect_to root_path if(!user_signed_in?)
		@facebook = Facebook.find(params[:facebook_id])
	end
	def create
		facebook_activation = FacebookActivation.new()
		facebook = Facebook.find(params[:facebook_id])		
		facebook_activation.facebook = facebook
		facebook_activation.user = current_user
		token = SecureRandom.urlsafe_base64(64, false) #ne doit pas être la même - rajouter un index + uniqness
		while FacebookActivation.find_by(token: token) do 
			token = SecureRandom.urlsafe_base64(64, false)
		end
		facebook_activation.token = token
		facebook_activation.save
		UserMailer.facebook_activation(facebook_activation, current_user).deliver_now
		flash[:info] = "Please check the Email attached to this Facebook profile"		
		redirect_to edit_user_registration_path(current_user)
	end
	
	def validate
		redirect_to root_path if(!user_signed_in?)
		@facebook_activation = FacebookActivation.find_by(token: params["token"], facebook_id: params["facebook_id"], user_id: params["uid"] )
		if current_user.id != @facebook_activation.user.id || @facebook_activation.nil?
			flash[:info] = "There is a problem" 
		else
			flash[:info] = "The Facebook profil: www.facebook.com/"+@facebook_activation.facebook.description+" is now yours!!!"
		end
		redirect_to edit_user_registration_path(current_user) 
	end
	

end
