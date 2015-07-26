class CallsController < ApplicationController

	def create
		@conversation = Conversation.find_or_initialize_by(id: params[:conversation_id]) 
		@call = Call.new()	
		
		search_key = description_by_display(call_params[:display])

		if(!search_key.nil?)
			@identable = search_key["category"].constantize.find_by_description(search_key["description"])
			if(@identable.nil?)
				@profile = Profile.new()
				@profile.identable = search_key["category"].constantize.new(description: search_key["description"]) 
				@user = PotentialUser.new()
				@user.profile = @profile
			else
				@profile = @identable.profile
				@user = @profile.profileable
			end
			@call = Call.find_or_initialize_by( conversation: @conversation, callable: @user ) 
			@call.supporters << current_user
		else
			#@call.errors[:base] << "No Profil matches your input"
		end
		
		if @call.save && !search_key.nil?
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


	def support
		@call = Call.find(params[:id])
		@call.unsupporters.delete(current_user) if @call.unsupporters.include?(current_user)
		@call.supporters << current_user
		redirect_to @call.conversation
	end

	def unsupport
		@call = Call.find(params[:id])	
		case 
			when @call.supporters.many?
				@call.supporters.delete(current_user) if @call.supporters.include?(current_user)
				@call.unsupporters << current_user
			when @call.supporters.count == 1	
				(@call.supporters.include?(current_user)) ? (@call.delete) : (@call.unsupporters << current_user)
		end
		redirect_to @call.conversation
	end

	def remove
		@call = Call.find(params[:id])	
		@call.supporters.delete(current_user) if @call.supporters.include?(current_user)
		@call.unsupporters.delete(current_user) if @call.unsupporters.include?(current_user)			
		@call.delete if !@call.supporters.any?
		redirect_to @call.conversation
	end


	private
		def call_params
    		params.require(:call).permit(:display)
		end
end
