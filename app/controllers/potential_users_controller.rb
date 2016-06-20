class PotentialUsersController < ApplicationController
	include UserObjectsModule
	def show
		@user = PotentialUser.find(params[:id]) 
		@objects =  objects_for_user(@user, nil)
		
		@conversation = Conversation.new()
		@conversation.posts.build()
	end
	
	def support
		potential_user = PotentialUser.find(params[:id]) 
		user_action = UserAction.find_or_initialize_by(creator: current_user, supportable: potential_user)
		user_action.update_attributes(support: "up")
		redirect_to potential_user
	end
	
	def unsupport
		potential_user = PotentialUser.find(params[:id]) 
		user_action = UserAction.find_or_initialize_by(creator: current_user, supportable: potential_user)
		user_action.update_attributes(support: "down")
		redirect_to potential_user
	end
	
	def remove_support
		potential_user = PotentialUser.find(params[:id]) 
		user_action = UserAction.find_or_initialize_by(creator: current_user, supportable: potential_user)
		user_action.destroy
		redirect_to potential_user
	end
end
