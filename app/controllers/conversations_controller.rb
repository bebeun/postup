class ConversationsController < ApplicationController
	def new
		if !user_signed_in?
			flash[:danger] = "Please sign in before creating a new conversation."
			redirect_to new_user_session_path
		else
			@conversation = Conversation.new(creator: current_user)
			@post = Post.new()
			@call = Call.new()
			@profiles = Profile::PROFILE_TYPES.collect{|x|  x.constantize.all}.flatten
			@profiles -= current_user.profiles 
		end
	end
	
	def show
		@conversation = Conversation.find(params[:id])
		if user_signed_in? 
			@aftf = Aftf.new() if current_user.can_aftf?(@conversation)
			@post = Post.new() if current_user.can_post?(@conversation)
			@call = Call.new() if current_user.can_call?(@conversation)
		end
	end
	
	private
		def conversation_params
    		params.require(:conversation).permit(:posts_attributes => [:title, :content], :calls_attributes => [:target])
		end
end
