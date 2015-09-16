class ConversationsController < ApplicationController
	def new
		if !user_signed_in?
			flash[:danger] = "Please sign in before creating a new conversation."
			redirect_to new_user_session_path
		else
			@post = Post.new()
			@call = Call.new()
			@profiles = Profile::PROFILE_TYPES.collect{|x|  x.constantize.all}.flatten
			@profiles -= current_user.profiles 
		end
	end
	
	def show
		@conversation = Conversation.find(params[:id])
		redirect_it root_path if @conversation.nil?
		if user_signed_in? 
			@aftf = Aftf.new()
			@post = Post.new() 
			@call = Call.new()
		end
	end
	
	private
		def conversation_params
    		params.require(:conversation).permit(:posts_attributes => [:title, :content], :calls_attributes => [:target])
		end
end
