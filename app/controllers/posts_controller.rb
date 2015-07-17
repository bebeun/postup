class PostsController < ApplicationController

	def create
		(params[:conversation_id].nil?) ? (@conversation = Conversation.new) : (@conversation = Conversation.find(params[:conversation_id]))
		@post = Post.new(post_params)
		@post.creator = current_user
		@post.conversation = @conversation
		@callout = Callout.new()
		(@post.save) ? (redirect_to @conversation) : (render '/conversations/show')
	end
	
	private
		def post_params
    		params.require(:post).permit(:title, :content)
		end
end
