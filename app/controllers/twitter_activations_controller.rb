class TwitterActivationsController < ApplicationController
	include ProfilesModule
	def new
		redirect_to root_path and return if(!user_signed_in?)#return root for not logged users
		@twitter = Twitter.find(params[:twitter_id])	
		
		cond1 = @twitter.nil?																		#refuse access to new twa page if twitter doesn't exist
		cond2 = current_user.has_this_profile?(@twitter)											#refuse access to new twa page if user already owns this twitter
		cond3 = @twitter.owner.is_user?																#refuse access to new twa page if this twitter is already owned by a User

		redirect_to edit_user_registration_path(current_user) and return if cond1 || cond2 || cond3 
	end
	
	def validate
		redirect_to root_path and return if(!user_signed_in?)#return root for not logged users
		@twitter = Twitter.find(params[:twitter_id])
		
		cond1 = @twitter.nil?																		#refuse access to new twa page if twitter doesn't exist
		cond2 = current_user.has_this_profile?(@twitter)											#refuse access to new twa page if user already owns this twitter
		cond3 = @twitter.owner.is_user?																#refuse access to new twa page if this twitter is already owned by a User
		
		if cond1 || cond2 || cond3 
			flash[:info] = "There is a problem"
		else
			flash[:info] = "The Twitter profil: www.twitter.com/"+@twitter.description+" is now yours!!!"	
			add_profile_to(current_user, @twitter)
		end
		
		redirect_to edit_user_registration_path(current_user) and return
	end
	
	def fail
		flash[:info] = "The Twitter profil is not yours!!!"
		redirect_to edit_user_registration_path(current_user) and return
	end
end
