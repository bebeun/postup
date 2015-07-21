class CallsController < ApplicationController

	def create
		(params[:conversation_id].nil?) ? (@conversation = Conversation.new) : (@conversation = Conversation.find(params[:conversation_id]))
		@profile = Profile.find_by_description(call_params[:description]) rescue nil
		if(@profile.nil?)
			@profile = Profile.new(call_params)
			@user = PotentialUser.new()
			@user.profile = @profile
		else
			@user = @profile.profileable
		end
		@call = Call.find_or_initialize_by( conversation: @conversation, callable: @user ) 
		@call.creators << current_user
		
		if @call.save
			redirect_to @conversation
		else
			@post = Post.new()
			
			@profilesUser = @conversation.calls.where(callable_type: "User").select { |w| w.creators.include?(current_user) }.collect{|x| x.callable }.collect{|x| x.profiles }.flatten
			@profilesPotentialUser = @conversation.calls.where(callable_type: "PotentialUser").select { |w| w.creators.include?(current_user) }.collect{|x| x.callable.profile }
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
