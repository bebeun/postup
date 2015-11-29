class PostsController < ApplicationController
	include ObjectTransferModule
	def create
		flash[:danger] = "Please sign in before creating a post." and redirect_to new_user_session_path  and return if !user_signed_in?

		@conversation = Conversation.find(params[:conversation_id]) rescue nil
		redirect_to new_conversation_path and return if @conversation.nil?
		
		@post = Post.new(post_params.merge(conversation: @conversation, creator: current_user))
		call = Call.find_by(conversation: @conversation, callable: current_user, post: nil, declined: false)
		
		if @post.save
			call.update_attributes(post: @post) and @post.transfer_up(call) if call.status == "active" if call
			current_user.supports(@post)
			redirect_to @conversation
		else
			@call = Call.new()
			render '/conversations/show'
		end
	end
	
	#redirect_to :back ?????
	def edit
		@post = Post.find(params[:id])
		@conversation = @post.conversation
		redirect_to @conversation and return if !user_signed_in? || !current_user.can_edit_post?(@post)
		@call = Call.new()		
		render '/conversations/edit' 
	end

	#redirect_to :back ?????
	def update
		@post = Post.find(params[:id])
		redirect_to @post.conversation and return if !user_signed_in? || !current_user.can_edit_post?(@post)
		@post.assign_attributes(post_params)
		changed = @post.changed?
		post_updated_at = @post.updated_at + 1.second
		if @post.save
			@post.object_actions.select{|x| x.updated_at > post_updated_at}.each{|x| x.destroy} if changed 
			@post.update_attributes(edited: true)
			redirect_to @post.conversation
		else
			@conversation = @post.conversation
			@call = Call.new()
			render '/conversations/edit'
		end
	end

	def support
		post = Post.find(params[:id])
		redirect_to :back and return if !user_signed_in? || !current_user.can_s_post?(post)
		current_user.supports(post)
		redirect_to :back
	end
	
	def unsupport
		post = Post.find(params[:id])
		redirect_to :back and return if !user_signed_in? || !current_user.can_u_post?(post)
		current_user.unsupports(post)
		redirect_to :back
	end
	
	def remove
		post = Post.find(params[:id])
		redirect_to :back and return if !user_signed_in? || !current_user.can_remove_s_or_u_post?(post)
		current_user.remove(post)
		redirect_to :back
	end
	
	
	def destroy
		post = Post.find(params[:id])
		conversation = post.conversation
		redirect_to :back and return if !user_signed_in? || !current_user.can_destroy_post?(post)
		post.call.update_attributes(post: nil) if post.call
		post.destroy 
		post.conversation.destroy and conv_destroy = true if !post.conversation.posts.any?
		#redirect to original page !!
		if URI(request.referer).path.split("/").include?("conversations")
			(conv_destroy) ? (redirect_to new_conversation_path) : (redirect_to conversation)
		else
			redirect_to :back 
		end
	end
	
	private
		def post_params
    		params.require(:post).permit(:content, :feeling)
		end
end
