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
			@profiles = Profile.all - current_user.profiles - @conversation.callouts.where(calloutable_type: "User", creator: current_user).collect{|x| x.calloutable }.collect{|x| x.profiles }.flatten - @conversation.callouts.where(calloutable_type: "PotentialUser", creator: current_user).collect{|x| x.calloutable.profile }
		end
	end

	private
		def conversation_params
    		params.require(:conversation).permit(:posts_attributes => [:title, :content], :callouts_attributes => [:target])
		end
end
