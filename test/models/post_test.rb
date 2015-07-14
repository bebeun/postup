require 'test_helper'

class PostTest < ActiveSupport::TestCase
  def setup
    @creator = User.new
	@conversation = Conversation.new
    @post = Post.new(creator: @creator, conversation: @conversation, content: "Lorem ipsum...", title: "...Sic amet doloribus...")
  end
  
  test "Post - should be valid" do
    assert @post.valid?
  end
  
  test "Post - creator should be present" do
    @post.creator = nil
    assert_not @post.valid?
  end
  
  test "Post - conversation should be present" do
    @post.conversation = nil
    assert_not @post.valid?
  end
  
  test "Post - title should be present" do
    @post.title = nil
    assert_not @post.valid?
  end
  
  test "Post - content should be present" do
    @post.content = nil
    assert_not @post.valid?
  end
 
end
