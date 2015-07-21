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
	
	private
		def post_params
    		params.require(:post).permit(:title, :content)
		end
end
