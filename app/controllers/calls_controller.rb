class CallsController < ApplicationController

	def create
		(params[:conversation_id].nil?) ? (@conversation = Conversation.new(creator: current_user)) : (@conversation = Conversation.find(params[:conversation_id]))	
		(@conversation.has_content?) ? (redirect_to @conversation and return) : (redirect_to new_conversation_path and return) if !current_user.can_call?(@conversation)

		case	
			when !call_params[:display].nil?
				profile = description_by_display(call_params[:display]) 
				callable = profile.owner and profile.save! if !profile.nil?
			when !call_params[:global_id].nil? 
				callable = get_user(call_params[:global_id])
		end
		
		(@conversation.has_content?) ? (redirect_to @conversation and return) : (redirect_to new_conversation_path and return) if callable.nil?

		@call = callable.parent_call(@conversation) if callable.can_post?(@conversation) 
		@call = Call.new( conversation: @conversation, callable: callable, parent: current_user.parent_call(@conversation)) if !callable.can_post?(@conversation)
		
		aftf = Aftf.select{|x| x.conversation == @call.conversation && x.creator == callable && x.alive?}.last #dirty !!!!!
		#switch aftf s/u to call s/u !!! ================================> inherited = true
		
		if @call.save!
			aftf.update_attributes!(accepted: true, answer_call: @call.parent) if aftf.alive? if !aftf.nil?
			@call.unsupporters.destroy(current_user) if @call.unsupporters.include?(current_user)
			@call.supporters << current_user if !@call.supporters.include?(current_user)
			redirect_to @conversation
		else
			@post = Post.new()	
			if @conversation.has_content? 
				render '/conversations/show'
			else
				render '/conversations/new'
			end
		end
	end


	def support
		@call = Call.find(params[:id])
		redirect_to @call.conversation and return if !current_user.can_s_or_u_call?(@call)
		@call.unsupporters.destroy(current_user) if @call.unsupporters.include?(current_user)
		@call.supporters << current_user
		redirect_to @call.conversation
	end

	def unsupport
		@call = Call.find(params[:id])
		@conversation = @call.conversation	
		redirect_to @conversation and return if !current_user.can_s_or_u_call?(@call) || current_user.can_not_unsupport_or_destroy?(@call)
		case 
			when @call.supporters.many?
				@call.supporters.destroy(current_user) if @call.supporters.include?(current_user)
				@call.unsupporters << current_user
			when @call.supporters.count == 1	
				(@call.supporters.include?(current_user)) ? (@call.destroy) : (@call.unsupporters << current_user)
		end
		if @conversation.has_content?
			redirect_to @conversation
		else
			@conversation.destroy
			redirect_to new_conversation_path
		end
	end
	
	def remove
		@call = Call.find(params[:id])	
		@conversation = @call.conversation
		redirect_to @conversation and return if current_user.can_not_unsupport_or_destroy?(@call)
		@call.supporters.destroy(current_user) if @call.supporters.include?(current_user)
		@call.unsupporters.destroy(current_user) if @call.unsupporters.include?(current_user)		
		@call.destroy if !@call.supporters.any?
		if @conversation.has_content?
			redirect_to @conversation
		else
			@conversation.destroy
			redirect_to new_conversation_path
		end
	end


	private
		def call_params
    		params.require(:call).permit(:display, :global_id)
		end
end
