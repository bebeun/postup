class CallsController < ApplicationController

	def create
		(params[:conversation_id].nil?) ? (@conversation = Conversation.new) : (@conversation = Conversation.find(params[:conversation_id])) #find by ??
		
		search_key = description_by_display(call_params[:display])
		
		@profilesUser = @conversation.calls.where(callable_type: "User").select { |w| w.creators.include?(current_user) }.collect{|x| x.callable }.collect{|x| x.profiles }.flatten
		@profilesPotentialUser = @conversation.calls.where(callable_type: "PotentialUser").select { |w| w.creators.include?(current_user) }.collect{|x| x.callable.profile }
		@profiles = Profile.all - current_user.profiles - @profilesUser - @profilesPotentialUser
		
		if(search_key.nil?)
			@post = Post.new()
			@call = Call.new()
			#============================>rajouter une gestion de l erreur
			if @conversation.posts.any? || @conversation.calls.any? 
				render '/conversations/show' and return
			else
				render '/conversations/new' and return
			end
		end
		
		
		@profile = Profile.find_by(search_key)
		if(@profile.nil?)
			@profile = Profile.new(search_key)
			
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
			
			if @conversation.posts.any? || @conversation.calls.any? 
				render '/conversations/show'
			else
				render '/conversations/new'
			end
		end
	end
	
	
	private
		def call_params
    		params.require(:call).permit(:display)
		end
end
