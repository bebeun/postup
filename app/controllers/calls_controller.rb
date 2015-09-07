class CallsController < ApplicationController

	def create
		(params[:conversation_id].nil?) ? (@conversation = Conversation.new(creator: current_user)) : (@conversation = Conversation.find(params[:conversation_id]))	
		@call = Call.new()	
		case	
			when !call_params[:display].nil?
				profile = description_by_display(call_params[:display])
				callable = profile.owner if !profile.nil?
			when !call_params[:callable_id].nil? 
				callable = get_user(call_params[:callable_id])
		end
		
		@call = Call.find_or_initialize_by( conversation: @conversation, callable: callable) 
		@call.creator = current_user if @call.creator.nil?
		@call.unsupporters.destroy(current_user) if @call.unsupporters.include?(current_user)
		@call.supporters << current_user if !@call.supporters.include?(current_user)
		
		if @call.save && (!profile.nil? || !call_params[:callable_id].nil? )
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
		@call.unsupporters.destroy(current_user) if @call.unsupporters.include?(current_user)
		@call.supporters << current_user
		redirect_to @call.conversation
	end

	def unsupport
		@call = Call.find(params[:id])	
		@conversation = @call.conversation
		case 
			when @call.supporters.many?
				@call.supporters.destroy(current_user) if @call.supporters.include?(current_user)
				@call.unsupporters << current_user
			when @call.supporters.count == 1	
				(@call.supporters.include?(current_user)) ? (@call.destroy) : (@call.unsupporters << current_user)
		end
		if @conversation.calls.any? || @conversation.posts.any? 
			redirect_to @conversation
		else
			@conversation.destroy
			redirect_to new_conversation_path
		end
	end

	def remove
		@call = Call.find(params[:id])	
		@call.supporters.destroy(current_user) if @call.supporters.include?(current_user)
		@call.unsupporters.destroy(current_user) if @call.unsupporters.include?(current_user)		
		@conversation = @call.conversation
		@call.destroy if !@call.supporters.any?
		if @conversation.calls.any? || @conversation.posts.any? 
			redirect_to @conversation
		else
			@conversation.destroy
			redirect_to new_conversation_path
		end
	end


	private
		def call_params
    		params.require(:call).permit(:display, :callable_id)
		end
end
