class PostsController < ApplicationController
	include ObjectTransferModule
	def create
		(params[:conversation_id].nil?) ? (@conversation = Conversation.new(creator: current_user)) : (@conversation = Conversation.find(params[:conversation_id]))
		(@conversation.has_content?) ? (redirect_to @conversation and return) : (redirect_to new_conversation_path and return) if !current_user.can_post?(@conversation)
		@post = Post.new(post_params.merge(conversation: @conversation, creator: current_user))
		call = Call.find_by(conversation: @conversation, callable: current_user, swept: false, post: nil)
		
		if @post.save
			call.update_attributes(post: @post) and @post.transfer_up(call) if call
			current_user.supports(@post)
			redirect_to @conversation
		else
			@call = Call.new()
			if @conversation.has_content?
				render '/conversations/show'
			else
				render '/conversations/new'
			end
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
	
	
	#redirect_to :back ?????
	def destroy
		post = Post.find(params[:id])
		conversation = post.conversation
		redirect_to :back and return if !user_signed_in? || !current_user.can_destroy_post?(post)
		post.call.update_attributes( post: nil) if post.call
		post.destroy 
		if URI(request.referer).path.split("/").include?("conversations")
			if conversation.has_content?
				redirect_to conversation
			else
				conversation.destroy
				redirect_to new_conversation_path
			end
		else
			redirect_to :back 
		end
	end
	
	private
		def post_params
    		params.require(:post).permit(:title, :content)
		end
end
