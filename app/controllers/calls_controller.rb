class CallsController < ApplicationController
	include ProfilesModule
	def create
		flash[:danger] = "Please sign in before creating a call." and redirect_to new_user_session_path  and return if !user_signed_in?

		@conversation = Conversation.find(params[:conversation_id]) rescue nil
		redirect_to new_conversation_path and return if @conversation.nil?	
		
		case	
			when !call_params[:display].nil?
				profile = description_by_display(call_params[:display]) 
				callable = profile.owner and profile.save! if !profile.nil?
			when !call_params[:global_id].nil? 
				callable = get_user(call_params[:global_id])
		end
		
		redirect_to @conversation and return if callable.nil? || callable == current_user
		
		@call = Call.find_by(conversation: @conversation, callable: callable, declined: false) 
		@call = Call.new(conversation: @conversation, callable: callable, declined: false, creator: current_user) if (@call.nil?) ? (true) : (@call.status == "active")
	
		if @call.save
			current_user.supports(@call)
			redirect_to @conversation
		else
			@post = Post.new()	
			render '/conversations/show'
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
