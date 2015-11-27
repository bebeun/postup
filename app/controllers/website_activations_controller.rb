class WebsiteActivationsController < ApplicationController
include ProfilesModule
	def new
		redirect_to root_path and return if(!user_signed_in?)#return root for not logged users
		@website = Website.find(params[:website_id])	
		
		cond1 = @website.nil?																		#refuse access to new wba page if website doesn't exist
		cond2 = current_user.has_this_profile?(@website)											#refuse access to new wba page if user already owns this website
		cond3 = @website.owner.is_user?																#refuse access to new wba page if this website is already owned by a User

		redirect_to edit_user_registration_path(current_user) and return if cond1 || cond2 || cond3 
	end
	
	def validate
		redirect_to root_path and return if(!user_signed_in?)#return root for not logged users
		@website = Website.find(params[:website_id])
		
		cond1 = @website.nil?																		#refuse access to new wba page if website doesn't exist
		cond2 = current_user.has_this_profile?(@website)											#refuse access to new wba page if user already owns this website
		cond3 = @website.owner.is_user?																#refuse access to new wba page if this website is already owned by a User
		
		if cond1 || cond2 || cond3 
			flash[:info] = "There is a problem"
		else
			flash[:info] = "The Website profil: www."+@website.description+" is now yours!!!"	
			add_profile_to(current_user, @website)
		end
		
		redirect_to edit_user_registration_path(current_user) and return
	end
	
	def fail
		flash[:info] = "The Website profil is not yours!!!"
		redirect_to edit_user_registration_path(current_user) and return
	end
end
