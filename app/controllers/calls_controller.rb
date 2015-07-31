class CallsController < ApplicationController

	def create
		@conversation = Conversation.find_or_initialize_by(id: params[:conversation_id]) 
		@call = Call.new()	
		case	
			when !call_params[:display].nil?
				profile = description_by_display(call_params[:display])
				if !profile.nil?
					@call = Call.find_or_initialize_by( conversation: @conversation, callable: profile.profileable) 
					@call.supporters << current_user
				end
				
			when !call_params[:callable_id].nil? && !call_params[:callable_type].nil?
				@call = Call.find_or_initialize_by( conversation: @conversation, callable_id: call_params[:callable_id], callable_type: call_params[:callable_type] ) 
				@call.supporters << current_user
		end
		
		if @call.save && (!profile.nil? || (!call_params[:callable_id].nil? && !call_params[:callable_type].nil?))
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
		@conversation = @call.conversation
		case 
			when @call.supporters.many?
				@call.supporters.delete(current_user) if @call.supporters.include?(current_user)
				@call.unsupporters << current_user
			when @call.supporters.count == 1	
				(@call.supporters.include?(current_user)) ? (@call.delete) : (@call.unsupporters << current_user)
		end
		if @conversation.calls.any? || @conversation.posts.any? 
			redirect_to @conversation
		else
			redirect_to new_conversation_path
		end
	end

	def remove
		@call = Call.find(params[:id])	
		@call.supporters.delete(current_user) if @call.supporters.include?(current_user)
		@call.unsupporters.delete(current_user) if @call.unsupporters.include?(current_user)		
		@conversation = @call.conversation
		@call.delete if !@call.supporters.any?
		if @conversation.calls.any? || @conversation.posts.any? 
			redirect_to @call.conversation
		else
			@conversation.delete
			redirect_to new_conversation_path
		end
	end


	private
		def call_params
    		params.require(:call).permit(:display, :callable_id, :callable_type)
		end
end
