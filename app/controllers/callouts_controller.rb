class CalloutsController < ApplicationController

	def create
		@conversation = Conversation.find(params[:conversation_id])
		@target = User.find(callout_params[:target_id]) rescue nil		
		@callout = Callout.new()
		@callout.creator = current_user
		@callout.target = @target
		@callout.conversation = @conversation
		@post = Post.new()
		(@callout.save) ? (redirect_to @conversation) : (render '/conversations/show')
	end
	
	private
		def callout_params
    		params.require(:callout).permit(:target_id)
		end
end
