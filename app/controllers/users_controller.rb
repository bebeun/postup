class UsersController < ApplicationController
	include UserObjectsModule
	def show
		@user = User.find(params[:id]) 
		@objects = objects_for_user(@user, current_user)
		
		@conversation = Conversation.new()
		@conversation.posts.build()
	end
		
end
