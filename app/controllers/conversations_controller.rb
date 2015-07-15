class ConversationsController < ApplicationController
	def new
		@conversation = Conversation.new()
		@conversation.posts << Post.new()
		@users = User.all()
	end
	def create
		@conversation = Conversation.new(conversation_params)
		if @conversation.save
			redirect_to @conversation
		else
			render 'new'
		end
	end
	
	def show
		@conversation = Conversation.find(params[:id])
	end
	
	private
		def conversation_params
    		params.require(:conversation).permit(:posts_attributes => [:title, :content, :user_id])
		end
end
