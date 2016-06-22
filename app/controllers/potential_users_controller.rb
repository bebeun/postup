class PotentialUsersController < ApplicationController
	include UserObjectsModule
	def show
		@user = PotentialUser.find(params[:id]) 
		@objects =  objects_for_user(@user, nil)
		
		@conversation = Conversation.new()
		@conversation.posts.build()
	end
	
end
