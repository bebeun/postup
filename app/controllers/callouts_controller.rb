class CalloutsController < ApplicationController

	def create
		(params[:conversation_id].nil?) ? (@conversation = Conversation.new) : (@conversation = Conversation.find(params[:conversation_id]))
		@profile = Profile.find_by_description(callout_params[:description]) rescue nil
		if(@profile.nil?)
			@profile = Profile.create(callout_params)
			@user = PotentialUser.new()
			@user.profile = @profile
		else
			@user = @profile.profileable
		end
		@callout = Callout.new()
		@callout.creator = current_user
		@callout.conversation = @conversation
		@callout.calloutable = @user
		
		if @callout.save
			redirect_to @conversation
		else
			@post = Post.new()
			@profiles = Profile.all - current_user.profiles - @conversation.callouts.where(calloutable_type: "User").collect{|x| x.calloutable }.collect{|x| x.profiles }.flatten - @conversation.callouts.where(calloutable_type: "PotentialUser").collect{|x| x.calloutable.profile }
			if @conversation.posts.any? || @conversation.callouts.any? 
				render '/conversations/show'
			else
				render '/conversations/new'
			end
		end
	end
	
	
	private
		def callout_params
    		params.require(:callout).permit(:description)
		end
end
