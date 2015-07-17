class CalloutsController < ApplicationController

	def create
		(params[:conversation_id].nil?) ? (@conversation = Conversation.new) : (@conversation = Conversation.find(params[:conversation_id]))
		@profile = Profile.find_by_description(callout_params[:description]) rescue nil
		if(@profile.nil?)
			puts "=================> PROFILE NOUVEAU"
			@profile = Profile.create(callout_params)
			@user = PotentialUser.new()
			@user.profile = @profile
			@user.save! #nécessaire ??
		else
			puts "=================> PROFILE DEJA VU"
			@user = @profile.profileable
		end
		puts "=================> ID du user : "+@user.id.to_s
		@callout = Callout.new()
		@callout.creator = current_user
		@callout.conversation = @conversation
		@callout.calloutable = @user
		@post = Post.new()
		(@callout.save) ? (redirect_to @conversation) : (render '/conversations/show')
	end
	
	
	private
		def callout_params
    		params.require(:callout).permit(:description)
		end
end
