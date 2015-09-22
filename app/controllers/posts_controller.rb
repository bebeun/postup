class PostsController < ApplicationController
	def create
		(params[:conversation_id].nil?) ? (@conversation = Conversation.new(creator: current_user)) : (@conversation = Conversation.find(params[:conversation_id]))
		(@conversation.has_content?) ? (redirect_to @conversation and return) : (redirect_to new_conversation_path and return) if !current_user.can_post?(@conversation)
		@post = Post.new(post_params.merge(conversation: @conversation, parent: current_user.parent_call(@conversation)))
		@post.supporters << current_user
		#switch call s/u to post s/u !!!   ================================>  inherited = true
		if @post.save
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
		redirect_to @conversation and return if !user_signed_in? || !current_user.can_edit_or_destroy?(@post)
		@call = Call.new()		
		render '/conversations/edit' 
	end

	def update
		@post = Post.find(params[:id])
		redirect_to @post.conversation and return if !user_signed_in? || !current_user.can_edit_or_destroy?(@post)
		@post.assign_attributes(post_params)
		changed = @post.changed?
		if @post.save
			@post.supporters.destroy_all and @post.unsupporters.destroy_all and @post.supporters << current_user if changed
			redirect_to @post.conversation
		else
			@conversation = @post.conversation
			@call = Call.new()
			render '/conversations/edit'
		end
	end

	def support
		@post = Post.find(params[:id])
		redirect_to @post.conversation and return if !user_signed_in? || current_user == @post.creator || @post.supporters.include?(current_user)
		@post.unsupporters.destroy(current_user) if @post.unsupporters.include?(current_user)
		@post.supporters << current_user 
		redirect_to @post.conversation
	end
	
	def unsupport
		@post = Post.find(params[:id])
		redirect_to @post.conversation and return if !user_signed_in? || current_user == @post.creator || @post.unsupporters.include?(current_user)
		@post.supporters.destroy(current_user) if @post.supporters.include?(current_user)
		@post.unsupporters << current_user 
		redirect_to @post.conversation
	end
	
	def remove
		@post = Post.find(params[:id])
		redirect_to @post.conversation and return if !user_signed_in? || current_user == @post.creator
		@post.supporters.destroy(current_user) if @post.supporters.include?(current_user)
		@post.unsupporters.destroy(current_user) if @post.unsupporters.include?(current_user)
		redirect_to @post.conversation
	end
	
	def hide
		@post = Post.find(params[:id])
		redirect_to @post.conversation and return if !user_signed_in? || !current_user.can_hide?(@post)
		@post.update_attributes!(visible: false)
		@post.supporters.destroy(current_user) if @post.supporters.include?(current_user)
		@post.unsupporters.destroy(current_user) if @post.unsupporters.include?(current_user)
		redirect_to @post.conversation
	end
	
	def destroy
		@post = Post.find(params[:id])
		@conversation = @post.conversation
		redirect_to @conversation and return if !user_signed_in? || !current_user.can_edit_or_destroy?(@post)
		@post.destroy if @post.creator == current_user
		if @conversation.has_content?
			redirect_to @conversation
		else
			@conversation.destroy
			redirect_to new_conversation_path
		end
	end
	
	private
		def post_params
    		params.require(:post).permit(:title, :content)
		end
end
