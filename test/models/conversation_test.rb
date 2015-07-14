require 'test_helper'

class ConversationTest < ActiveSupport::TestCase

	def setup
		@creator = User.new
		@post = Post.new(title: 'title', content: 'content', creator: @creator)
		@conversation = Conversation.new
		@conversation.posts << @post
	end
	test "Conversation  - should be valid" do
		assert @conversation.valid?, @conversation.errors.messages
	end
end
