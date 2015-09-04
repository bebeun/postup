class PotentialUsersController < ApplicationController
	def show
		@potential_user = PotentialUser.find(params[:id]) 
		@callins = @potential_user.callins
		@conversations = @callins.collect{|x| x.conversation } 
	end
	
	def support
		potential_user = PotentialUser.find(params[:id]) 
		#@user.supporters << current_user
		user_action = UserAction.find_or_initialize_by(creator: current_user, supportable: potential_user)
		user_action.update_attributes(:support => "up")
		redirect_to potential_user
	end
	
	def unsupport
		potential_user = PotentialUser.find(params[:id]) 
		user_action = UserAction.find_or_initialize_by(creator: current_user, supportable: potential_user)
		user_action.update_attributes(:support => "down")
		redirect_to potential_user
	end
	
	def remove_support
		potential_user = PotentialUser.find(params[:id]) 
		user_action = UserAction.find_or_initialize_by(creator: current_user, supportable: potential_user)
		user_action.destroy
		redirect_to potential_user
	end
end
