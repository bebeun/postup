class ConversationsController < ApplicationController
	include UserObjectsModule
	def new
		flash[:danger] = "Please sign in before creating a new conversation." and redirect_to new_user_session_path(redirect_to: new_conversation_path) and return if !user_signed_in?

		@conversation = Conversation.new()
		@conversation.posts.build()
	end
	
	def create
		flash[:danger] = "Please sign in before creating a new conversation." and redirect_to new_user_session_path  and return if !user_signed_in?

		@conversation = Conversation.new(conversation_params)
		@conversation.creator = current_user
		@conversation.posts[0].creator = current_user
		
		if params[:from] == "User" || params[:from] == "PotentialUser"
			@user = params[:from].constantize.find(params[:user]) 
			@conversation.calls.build(creator: current_user, callable: @user) if current_user != @user
		end
		
		if @conversation.save
			current_user.supports(@conversation.posts[0])
			current_user.supports(@conversation.calls[0]) if @conversation.calls[0] 
			#current_user.supports(@conversation)
			redirect_to @conversation and return if params[:from] == "Conversation"
			redirect_to @user and return if params[:from] == "User" || params[:from] == "PotentialUser"
		else
			render '/conversations/new' if params[:from] == "Conversation"
			@objects = objects_for_user(@user, current_user) and render '/users/show' if params[:from] == "User" 
			@objects = objects_for_user(@user, current_user) and render '/potential_users/show' if params[:from] == "PotentialUser"
		end
	end
	
	def show
		@conversation = Conversation.find(params[:id])
		if user_signed_in? 
			@post = Post.new() if current_user.can_post?(@conversation)
			@call = Call.new() if current_user.can_call?(@conversation)
		end
	end
	
	private
		def conversation_params
    		params.require(:conversation).permit( :posts_attributes => [:content, :feeling], :calls_attributes => [:callable_type, :callable_id])
		end
end
