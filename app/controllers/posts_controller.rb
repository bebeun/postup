class PostsController < ApplicationController

	def create
		(params[:conversation_id].nil?) ? (@conversation = Conversation.new) : (@conversation = Conversation.find(params[:conversation_id]))
		@post = Post.new(post_params.merge(creator: current_user, conversation: @conversation))
		if @post.save
			redirect_to @conversation
		else
			@call = Call.new()
			if @conversation.posts.any? || @conversation.calls.any? 
				render '/conversations/show'
			else
				render '/conversations/new'
			end
		end
	end
	
	def support
		@post = Post.find(params[:id])
		@post.unsupporters.delete(current_user) if @post.unsupporters.include?(current_user)
		@post.supporters << current_user if current_user != @post.creator && !@post.supporters.include?(current_user)
		redirect_to @post.conversation
	end
	
	def unsupport
		@post = Post.find(params[:id])
		@post.supporters.delete(current_user) if @post.supporters.include?(current_user)
		@post.unsupporters << current_user if current_user != @post.creator && !@post.unsupporters.include?(current_user)
		redirect_to @post.conversation
	end
	
	def remove
		@post = Post.find(params[:id])
		@post.supporters.delete(current_user) if @post.supporters.include?(current_user)
		@post.unsupporters.delete(current_user) if @post.unsupporters.include?(current_user)
		redirect_to @post.conversation
	end
	
	private
		def post_params
    		params.require(:post).permit(:title, :content)
		end
end
