class CalloutsController < ApplicationController

	def create
		(params[:conversation_id].nil?) ? (@conversation = Conversation.new) : (@conversation = Conversation.find(params[:conversation_id]))
		@profile = Profile.find_by_description(callout_params[:description]) rescue nil
		#puts " description =================================> "+@profile.description.to_s
		if(@profile.nil?)
			@profile = Profile.create(callout_params)
			@user = PotentialUser.new()
			@user.profile = @profile
		else
			@user = @profile.profileable
			puts " user id =================================> "+@user.id.to_s
		end
		@callout = Callout.new()
		@callout.creator = current_user
		@callout.conversation = @conversation
		@callout.calloutable = @user
		
		if @callout.save
			redirect_to @conversation
		else
			@post = Post.new()
			@profilesUser = @conversation.callouts.where(calloutable_type: "User", creator: current_user).collect{|x| x.calloutable }.collect{|x| x.profiles }.flatten
			@profilesPotentialUser = @conversation.callouts.where(calloutable_type: "PotentialUser", creator: current_user).collect{|x| x.calloutable.profile }
			@profiles = Profile.all - current_user.profiles - @profilesUser - @profilesPotentialUser
			
			
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
