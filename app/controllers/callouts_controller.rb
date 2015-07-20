class CalloutsController < ApplicationController

	def create
		(params[:conversation_id].nil?) ? (@conversation = Conversation.new) : (@conversation = Conversation.find(params[:conversation_id]))
		@profile = Profile.find_by_description(callout_params[:description])
		if(@profile.nil?)
			@profile = Profile.new(callout_params) 
			@target = PotentialUser.new()
			@target.profile = @profile
			@target.save!
		else
			@target = @profile.profileable
		end
		
		@callout = Callout.find_or_initialize_by( conversation: @conversation )	
		@callout.users << current_user

			
		if @callout.save
			redirect_to @conversation
		else
			@post = Post.new()
			
			@profilesUser = @conversation.callouts.where(calloutable_type: "User").select { |w| w.users.include?(current_user) }.collect{|x| x.calloutable }.collect{|x| x.profiles }.flatten
			@profilesPotentialUser = @conversation.callouts.where(calloutable_type: "PotentialUser").select { |w| w.users.include?(current_user) }.collect{|x| x.calloutable.profile }
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
