class PostsController < ApplicationController

	def create
		(params[:conversation_id].nil?) ? (@conversation = Conversation.new) : (@conversation = Conversation.find(params[:conversation_id]))
		@post = Post.new(post_params)
		@post.creator = current_user
		@post.conversation = @conversation
		if @post.save
			redirect_to @conversation
		else
		
			@call = Call.new()
			@profilesUser = @conversation.calls.where(callable_type: "User").select { |w| w.creators.include?(current_user) }.collect{|x| x.callable }.collect{|x| x.profiles }.flatten
			@profilesPotentialUser = @conversation.calls.where(callable_type: "PotentialUser").select { |w| w.creators.include?(current_user) }.collect{|x| x.callable.profile }
			@profiles = Profile.all - current_user.profiles - @profilesUser - @profilesPotentialUser
			if @conversation.posts.any? || @conversation.calls.any? 

				render '/conversations/show'
			else
				render '/conversations/new'
			end
			
			
		end
	end
	
	def support
		@post = Post.find(params[:id].to_s)
		@postsupport = PostAction.find_or_initialize_by(post: @post, user: current_user)
		@postsupport.support = "up"
		@conversation = @post.conversation
		if @postsupport.save
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
	
	def unsupport
		@post = Post.find(params[:id].to_s)
		@postsupport = PostAction.find_or_initialize_by(post: @post, user: current_user)
		@postsupport.support = "down"
		@conversation = @post.conversation
		if @postsupport.save
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
	
	def remove
		@post = Post.find(params[:id].to_s)
		@postsupport = PostAction.find_by(post: @post, user: current_user)
		@postsupport.destroy!
		@conversation = @post.conversation
		if @postsupport.save
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
	
	private
		def post_params
    		params.require(:post).permit(:title, :content)
		end
end
