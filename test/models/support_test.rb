require 'test_helper'

class SupportTest < ActiveSupport::TestCase
	def setup
		@creator = User.new
		@post = Post.new
		@callout = Callout.new
		@support_callout = Support.new(supportable: @callout, creator: @creator)
		@support_post = Support.new(supportable: @post, creator: @creator)
	end
	
	test "support_callout - should be valid" do
		assert @support_callout.valid?
	end
	
	test "support_post - should be valid" do
		assert @support_post.valid?
	end
	
	test "support_callout -  creator should be present" do
		@support_callout.creator = nil
		assert_not @support_callout.valid?
	end
	
	test "support_post -  creator should be present" do
		@support_post.creator = nil
		assert_not @support_post.valid?
	end
	
	test "support_callout -  supportable should be present" do
		@support_callout.supportable = nil
		assert_not @support_callout.valid?
	end
	
	test "support_post -  supportable should be present" do
		@support_post.supportable = nil
		assert_not @support_post.valid?
	end
	
	test "support_post.supportable_type should be \"post\"" do
		assert_equal @support_post.supportable_type, "Post"
	end
	
	test "support_callout.supportable_type should be \"Callout\"" do
		assert_equal @support_callout.supportable_type, "Callout"
	end
end
