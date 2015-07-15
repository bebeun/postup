class ConversationsController < ApplicationController
	def new
		if !user_signed_in?
			flash[:danger] = "Please sign in before creating a new conversation."
			redirect_to new_user_session_path
		end
		@conversation = Conversation.new()
		@conversation.posts << Post.new()
	end
	
	def create
		@post = Post.new(conversation_params["posts_attributes"]["0"])
		@post.creator = current_user
		@conversation = Conversation.new()
		@conversation.posts << @post
		if @conversation.save
			redirect_to @conversation
		else
			render 'new'
		end
	end
	
	def show
		@conversation = Conversation.find(params[:id])
		if user_signed_in? 
			@post = Post.new() 
			@callout = Callout.new()
		end
	end

	private
		def conversation_params
    		params.require(:conversation).permit(:posts_attributes => [:title, :content])
		end
end
