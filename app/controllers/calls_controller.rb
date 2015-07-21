class CallsController < ApplicationController

	def create
		(params[:conversation_id].nil?) ? (@conversation = Conversation.new) : (@conversation = Conversation.find(params[:conversation_id]))
		@profile = Profile.find_by_description(call_params[:description]) rescue nil
		#puts " description =================================> "+@profile.description.to_s
		if(@profile.nil?)
			@profile = Profile.create(call_params)
			@user = PotentialUser.new()
			@user.profile = @profile
		else
			@user = @profile.profileable
			puts " user id =================================> "+@user.id.to_s
		end
		@call = Call.new()
		@call.creator = current_user
		@call.conversation = @conversation
		@call.callable = @user
		
		if @call.save
			redirect_to @conversation
		else
			@post = Post.new()
			@profilesUser = @conversation.calls.where(callable_type: "User", creator: current_user).collect{|x| x.callable }.collect{|x| x.profiles }.flatten
			@profilesPotentialUser = @conversation.calls.where(callable_type: "PotentialUser", creator: current_user).collect{|x| x.callable.profile }
			@profiles = Profile.all - current_user.profiles - @profilesUser - @profilesPotentialUser
			
			
			if @conversation.posts.any? || @conversation.calls.any? 
				render '/conversations/show'
			else
				render '/conversations/new'
			end
		end
	end
	
	
	private
		def call_params
    		params.require(:call).permit(:description)
		end
end
