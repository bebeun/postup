class ConversationsController < ApplicationController
	def new
		if !user_signed_in?
			flash[:danger] = "Please sign in before creating a new conversation."
			redirect_to new_user_session_path
		else
			@post = Post.new()
			@callout = Callout.new()
			@profiles = Profile.all - current_user.profiles
		end
	end
	
	def show
		@conversation = Conversation.find(params[:id])
		if user_signed_in? 
			@post = Post.new() 
			@callout = Callout.new()
			@profiles = Profile.all - current_user.profiles #enlever tous ceux déja call out
		end
	end

	private
		def conversation_params
    		params.require(:conversation).permit(:posts_attributes => [:title, :content], :callouts_attributes => [:target])
		end
end
