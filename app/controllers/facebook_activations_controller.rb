class FacebookActivationsController < ApplicationController
	include ProfilesModule
	def new
		redirect_to root_path and return if(!user_signed_in?)#return root for not logged users
		@facebook = Facebook.find(params[:facebook_id])	
		
		cond1 = @facebook.nil?																	#refuse access to new fba page if facebook doesn't exist
			#=============>
		cond2 = current_user.has_pending_facebook_activations?(@facebook)						#refuse access to new fba page if creator already asked for this facebook
		cond3 = current_user.has_this_profile?(@facebook)										#refuse access to new fba page if user already owns this facebook
		cond4 = @facebook.owner.is_user?														#refuse access to new fba page if this facebook is already owned by a User
		cond5 = @facebook.facebook_activations.where(creator: current_user, reported: true).any?	#this user already ask for this facebook and this was reported

		redirect_to edit_user_registration_path(current_user) and return if cond1 || cond2 || cond3 || cond4 || cond5
		@facebook_activation = FacebookActivation.new()
	end

	def create		
		redirect_to root_path and return if(!user_signed_in?)
		facebook = Facebook.find(params[:facebook_id])
				
		cond1 = facebook.nil?																	#refuse to create fba if facebook doesn't exist
			#=============>
		cond2 = current_user.has_pending_facebook_activations?(facebook)						#refuse to create fba if creator already asked for this facebook
		cond3 = current_user.has_this_profile?(facebook)										#refuse to create fba if creator already owns this facebook
		cond4 = facebook.owner.is_user?															#refuse to create fba if this facebook is already owned by a User
		cond5 = facebook.facebook_activations.where(creator: current_user, reported: true).any?	#this user already ask for this facebook and this was reported

		if cond1 || cond2 || cond3 || cond4 || cond5
			flash[:info] = "You can t do this"	
		else
			facebook_activation = FacebookActivation.create(facebook: facebook, creator: current_user, mailnumber: 1)	
			UserMailer.facebook_activation(facebook_activation, current_user).deliver_now
			flash[:info] = "Please check the Email attached to this Facebook profile"	
		end
		redirect_to edit_user_registration_path(current_user)	
	end
	
	def resend
		redirect_to root_path and return if(!user_signed_in?)
		facebook_activation = FacebookActivation.find(params[:id])
		
		cond1 = facebook_activation.nil?   												#if the activation was never created
			#=============>
		cond2 = !current_user.has_this_facebook_activation?(facebook_activation)		#or was created by another user (not current_user)
		cond3 = facebook_activation.activated											#or is already activated
		cond4 = facebook_activation.mailnumber > 4										#or too many activation mails sent
		cond5 = facebook_activation.reported											#the activation has been reported as fraudulent
				
		if cond1 || cond2 || cond3 || cond4 || cond5
			flash[:info] = "There is a problem" 
		else
			facebook_activation.touch	
			facebook_activation.increment!(:mailnumber)
			UserMailer.facebook_activation(facebook_activation, current_user).deliver_now
			flash[:info] = "Please check the Email attached to this Facebook profile"
		end
		redirect_to edit_user_registration_path(current_user)	
	end
	
	
	def validate
		redirect_to root_path and return if(!user_signed_in?)	 #friendly redirect	
		facebook_activation = FacebookActivation.find_by(token: params[:token], facebook_id: params[:facebook_id], user_id: params[:uid] )
		facebook = Facebook.find(params[:facebook_id])
		
		cond1 = facebook_activation.nil? || facebook.nil?								#if the activation was never created or the facebook doesn t exist*
			#=============>
		cond2 = !current_user.has_this_facebook_activation?(facebook_activation)		#or was created by another user (not current_user)
		cond3 = facebook_activation.activated											#or is already activated
		cond4 = facebook_activation.reported											#the activation has been reported as fraudulent
		
		if cond1 || cond2 || cond3  || cond4
			flash[:info] = "There is a problem" 
		else
			flash[:info] = "The Facebook profil: www.facebook.com/"+facebook_activation.facebook.description+" is now yours!!!"	
			FacebookActivation.all.where(facebook_id: params[:facebook_id]).where.not(id: facebook_activation.id).destroy_all
			facebook_activation.update_attribute(:activated, true)
			add_profile_to(current_user, facebook_activation.facebook)
		end
		redirect_to edit_user_registration_path(current_user) 
	end
	
	def report_page
		@facebook_activation = FacebookActivation.find_by(id: params[:id], facebook: params[:facebook_id], token: params[:token])
	
		cond1 = @facebook_activation.nil? 												#if the activation was never created 
			#=============>
		cond2 = @facebook_activation.activated											#or is already activated
		cond3 = @facebook_activation.reported											#the activation has been reported as fraudulent
		(user_signed_in? ) ? (cond4 = current_user.has_this_facebook_activation?(@facebook_activation)) : (cond4 = false)#current_user certainly made a mistake by trying to report instead of validating the activation

		flash[:info] = "There is a problem" if cond1 || cond2
		flash[:info] = "This Facebook Activation is has already been reported. www.facebook.com/"+@facebook_activation.facebook.description+" isn't owned by "+@facebook_activation.creator.name if cond3
		flash[:info] = "Mhhhh...you can t report an activation process you initiated yourself" if cond4
		
		redirect_to root_path and return  if cond1 || cond2 || cond3 || cond4
	end
	
	def report_as_abusive
		facebook_activation = FacebookActivation.find_by(id: params[:id], facebook: params[:facebook_id], token: params[:token])
		facebook = Facebook.find(params[:facebook_id])
	
		cond1 = facebook_activation.nil? || facebook.nil?								#if the activation was never created or the facebook doesn t exist
			#=============>
		cond2 = facebook_activation.activated											#or is already activated
		cond3 = facebook_activation.reported											#the activation has been reported as fraudulent
		
		if cond1 || cond2
			flash[:info] = "There is a problem" 
		else
			if !cond3
				facebook_activation.update_attribute(:reported, true) 
				flash[:info] = "This Facebook Activation is cancelled and reported. www.facebook.com/"+facebook_activation.facebook.description+" isn't owned by "+facebook_activation.creator.name
			else
				flash[:info] = "This Facebook Activation is has already been reported. www.facebook.com/"+facebook_activation.facebook.description+" isn't owned by "+facebook_activation.creator.name
			end
		end
		redirect_to root_path	
	end
	
	def cancel
		redirect_to root_path and return if(!user_signed_in?)
		facebook_activation = FacebookActivation.find(params[:id])
		
		cond1 = facebook_activation.nil?   												#if the activation was never created
			#=============>
		cond2 = !current_user.has_this_facebook_activation?(facebook_activation)		#or was created by another user (not current_user)
		cond3 = facebook_activation.activated											#or is already activated
		cond4 = facebook_activation.reported											#the activation has been reported as fraudulent
		
		if cond1 || cond2 || cond3 || cond4
			flash[:info] = "There is a problem" 
		else
			facebook_activation.destroy
			flash[:info] = "Facebook Activation cancelled"
		end
		redirect_to edit_user_registration_path(current_user)	
	end
end