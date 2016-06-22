class CallsController < ApplicationController
	include ProfilesModule
	def create
		return if !user_signed_in?

		@conversation = Conversation.find(params[:conversation_id]) rescue nil
		return if @conversation.nil?	
		
		case	
			when !call_params[:display].nil?
				profile = description_by_display(call_params[:display]) 
				callable = profile.owner and profile.save! if !profile.nil?
			when !call_params[:global_id].nil? 
				callable = get_user(call_params[:global_id])
		end
		
		return if callable.nil? || callable == current_user
		
		@call = Call.find_by(conversation: @conversation, callable: callable, declined: false) 

		@call = Call.new(conversation: @conversation, callable: callable, declined: false) if ((@call.nil?) ? (true) : (@call.status != "active"))
	
		if @call.save
			current_user.supports(@call)
			@call = Call.new()	
		end
		
		@post = Post.new()
		respond_to do |format|
			format.js {render "/conversations/show" }
    	end
	end
	
	def support
		@call = Call.find(params[:id])
		redirect_to :back and return if !current_user.can_s_call?(@call)
		current_user.supports(@call) 

		@conversation = @call.conversation and @post = Post.new() and @call = Call.new()
		respond_to do |format|
			format.js {render "/conversations/show"}
			format.html {redirect_to :back}
    	end
	end

	def unsupport   
		@call = Call.find(params[:id])
		redirect_to :back and return if !current_user.can_u_call?(@call)
		current_user.unsupports(@call) 

		@conversation = @call.conversation and @post = Post.new() and @call = Call.new()
		respond_to do |format|
			format.js {render "/conversations/show"}
			format.html {redirect_to :back}
    	end
	end
	
	def remove   
		@call = Call.find(params[:id])	
		redirect_to :back and return if !current_user.can_remove_s_or_u_call?(@call)
		current_user.remove(@call)	

		@conversation = @call.conversation and @post = Post.new() and @call = Call.new()
		respond_to do |format|
			format.js {render "/conversations/show"}
			format.html {redirect_to :back}
    	end
	end

	def decline  
		@call = Call.find(params[:id])	
		redirect_to :back and return if !current_user.can_answer_call?(@call)
		@call.update_attributes(declined: true)

		@conversation = @call.conversation and @post = Post.new() and @call = Call.new()
		respond_to do |format|
			format.js {render "/conversations/show"}
			format.html {redirect_to :back}
    	end
	end

	private
		def call_params
    		params.require(:call).permit(:display, :global_id)
		end
end
