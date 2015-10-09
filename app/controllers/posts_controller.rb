class PostsController < ApplicationController
	def create
		(params[:conversation_id].nil?) ? (@conversation = Conversation.new(creator: current_user)) : (@conversation = Conversation.find(params[:conversation_id]))
		(@conversation.has_content?) ? (redirect_to @conversation and return) : (redirect_to new_conversation_path and return) if !current_user.can_post?(@conversation)
		@post = Post.new(post_params.merge(conversation: @conversation, parent: current_user.parent_call(@conversation)))

		if @post.save!
			current_user.supports(@post)
			@post.transfer_post_s_u_up
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
	
	def edit
		@post = Post.find(params[:id])
		@conversation = @post.conversation
		redirect_to @conversation and return if !user_signed_in? || !current_user.can_edit_post?(@post)
		@call = Call.new()		
		render '/conversations/edit' 
	end

	def update
		@post = Post.find(params[:id])
		redirect_to @post.conversation and return if !user_signed_in? || !current_user.can_destroy_post?(@post)
		@post.assign_attributes(post_params)
		#changed = @post.changed?
		#post_updated_at = @post.updated_at
		if @post.save
			#post.object_actions.where("updated_at >= ?", post_updated_at).destroy_all and @post.object_actions.where("updated_at >= ?", post_updated_at).destroy_all if changed 
			redirect_to @post.conversation
		else
			@conversation = @post.conversation
			@call = Call.new()
			render '/conversations/edit'
		end
	end

	def support
		post = Post.find(params[:id])
		redirect_to post.conversation and return if !user_signed_in? || !current_user.can_s_post?(post)
		current_user.supports(post)
		redirect_to post.conversation
	end
	
	def unsupport
		post = Post.find(params[:id])
		redirect_to post.conversation and return if !user_signed_in? || !current_user.can_u_post?(post)
		current_user.unsupports(post)
		redirect_to post.conversation
	end
	
	def remove
		post = Post.find(params[:id])
		redirect_to post.conversation and return if !user_signed_in? || !current_user.can_remove_s_or_u_post?(post)
		current_user.remove(post)
		redirect_to post.conversation
	end
	
	def hide
		post = Post.find(params[:id])
		redirect_to post.conversation and return if !user_signed_in? || !current_user.can_hide?(post)
		post.update_attributes!(visible: false)
		#current_user.remove(post)
		redirect_to post.conversation
	end
	
	def destroy
		post = Post.find(params[:id])
		conversation = post.conversation
		redirect_to conversation and return if !user_signed_in? || !current_user.can_destroy_post?(post)
		post.destroy 
		if conversation.has_content?
			redirect_to conversation
		else
			conversation.destroy
			redirect_to new_conversation_path
		end
	end
	
	private
		def post_params
    		params.require(:post).permit(:title, :content)
		end
end
