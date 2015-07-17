class PostsController < ApplicationController

	def create
		(params[:conversation_id].nil?) ? (@conversation = Conversation.new) : (@conversation = Conversation.find(params[:conversation_id]))
		@post = Post.new(post_params)
		@post.creator = current_user
		@post.conversation = @conversation
		if @post.save
			redirect_to @conversation
		else
			@callout = Callout.new()
			@profiles = Profile.all - current_user.profiles - @conversation.callouts.where(calloutable_type: "User").collect{|x| x.calloutable }.collect{|x| x.profiles }.flatten - @conversation.callouts.where(calloutable_type: "PotentialUser").collect{|x| x.calloutable.profile }
			if @conversation.posts.any? || @conversation.callouts.any? 
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
