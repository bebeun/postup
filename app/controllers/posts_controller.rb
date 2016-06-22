class PostsController < ApplicationController
	#include ObjectTransferModule
	def create
		return if !user_signed_in?

		@conversation = Conversation.find(params[:conversation_id]) rescue nil
		return if @conversation.nil?
		
		@post = Post.new(post_params.merge(conversation: @conversation, creator: current_user))
		call = Call.find_by(conversation: @conversation, callable: current_user, post: nil, declined: false)
		
		if @post.save
			call.update_attributes(post: @post) and @post.transfer_up(call) if call.status == "active" if call
			current_user.supports(@post)
			@post = Post.new()
		end

		@call = Call.new()
		respond_to do |format|
			format.js {render "/conversations/show"}
    	end
	end
	
	#redirect_to :back ?????
	def edit
		@back = request.referer
		@post = Post.find(params[:id])
		redirect_to @post.conversation and return if !user_signed_in? || !current_user.can_edit_post?(@post)
	end

	#redirect_to :back ?????
	def update
		@post = Post.find(params[:id])
		redirect_to @post.conversation and return if !user_signed_in? || !current_user.can_edit_post?(@post) || (params[:back] != conversation_url(@post.conversation) && params[:back] != user_url(@post.creator))
		@post.assign_attributes(post_params)
		changed = @post.changed?
		post_updated_at = @post.updated_at + 1.second
		if @post.save
			@post.object_actions.select{|x| x.updated_at > post_updated_at}.each{|x| x.destroy} if changed 
			@post.update_attributes(edited: true)
			redirect_to @post.conversation and return if params[:back] == conversation_url(@post.conversation)
			redirect_to @post.creator and return if params[:back] == user_url(@post.creator)
		else
			@back = params[:back]
			render '/posts/edit'
		end
	end

	def support
		post = Post.find(params[:id])
		redirect_to :back and return if !user_signed_in? || !current_user.can_s_post?(post)
		current_user.supports(post)
		@conversation = post.conversation and @post = Post.new() and @call = Call.new()
		
		respond_to do |format|
			format.js {render "/conversations/show"}
			format.html {redirect_to :back}
    	end
	end
	
	def unsupport
		post = Post.find(params[:id])
		redirect_to :back and return if !user_signed_in? || !current_user.can_u_post?(post)
		current_user.unsupports(post)
		@conversation = post.conversation and @post = Post.new() and @call = Call.new()

		respond_to do |format|
			format.js {render "/conversations/show"}
			format.html {redirect_to :back}
    	end
	end
	
	def remove
		post = Post.find(params[:id])
		redirect_to :back and return if !user_signed_in? || !current_user.can_remove_s_or_u_post?(post)
		current_user.remove(post)
		@conversation = post.conversation and @post = Post.new() and @call = Call.new()

		respond_to do |format|
			format.js {render "/conversations/show"}
			format.html {redirect_to :back}
    	end
	end
	

	
	private
		def post_params
    		params.require(:post).permit(:content, :feeling)
		end
end
