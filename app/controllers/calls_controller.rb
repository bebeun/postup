class CallsController < ApplicationController
	include ProfilesModule
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
		(@conversation.has_content?) ? (redirect_to @conversation and return) : (redirect_to new_conversation_path and return) if callable.nil? || callable == current_user
		
		@call = Call.find_by(conversation: @conversation, callable: callable, declined: false) 
		@call = Call.new(conversation: @conversation, callable: callable, declined: false, creator: current_user) if (@call.nil?) ? (true) : (@call.status == "active")
	
		if @call.save
			current_user.supports(@call)
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
		call = Call.find(params[:id])
		redirect_to :back and return if !current_user.can_s_call?(call)
		current_user.supports(call) 
		redirect_to :back
	end

	def unsupport   
		call = Call.find(params[:id])
		redirect_to :back and return if !current_user.can_u_call?(call)
		current_user.unsupports(call) 
		redirect_to :back
	end
	
	def remove   
		call = Call.find(params[:id])	
		redirect_to :back and return if !current_user.can_remove_s_or_u_call?(call)
		current_user.remove(call)	
		redirect_to :back
	end

	private
		def call_params
    		params.require(:call).permit(:display, :global_id)
		end
end
