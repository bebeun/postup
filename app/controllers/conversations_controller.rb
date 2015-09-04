class ConversationsController < ApplicationController
	def new
		if !user_signed_in?
			flash[:danger] = "Please sign in before creating a new conversation."
			redirect_to new_user_session_path
		else
			@post = Post.new()
			@call = Call.new()
			@profiles = Twitter.all + Facebook.all - current_user.profiles #automatically add all profile type ??
		end
	end
	
	def show
		@conversation = Conversation.find(params[:id])
		if user_signed_in? 
			@post = Post.new() 
			@call = Call.new()

		end
	end
	
	private
		def conversation_params
    		params.require(:conversation).permit(:posts_attributes => [:title, :content], :calls_attributes => [:target])
		end
end
