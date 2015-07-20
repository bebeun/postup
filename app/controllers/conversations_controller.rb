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
			@profilesUser = @conversation.callouts.where(calloutable_type: "User").select { |w| w.users.include?(current_user) }.collect{|x| x.calloutable }.collect{|x| x.profiles }.flatten
			@profilesPotentialUser = @conversation.callouts.where(calloutable_type: "PotentialUser").select { |w| w.users.include?(current_user) }.collect{|x| x.calloutable.profile }
			@profiles = Profile.all - current_user.profiles - @profilesUser - @profilesPotentialUser
		end
	end

	private
		def conversation_params
    		params.require(:conversation).permit(:posts_attributes => [:title, :content], :callouts_attributes => [:target])
		end
end
