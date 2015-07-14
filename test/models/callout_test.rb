require 'test_helper'

class CalloutTest < ActiveSupport::TestCase
	def setup
		@creator = User.new;
		@target = User.new;
		@conversation = Conversation.new
		@callout = Callout.new(creator: @creator, target: @target, conversation: @conversation)
	end
	
	test "Callout - should be valid" do
		assert @callout.valid?
	end
	
	test "Callout - creator should be present" do
		@callout.creator = nil
		assert_not @callout.valid?
	end
	
	test "Callout - target should be present" do
		@callout.target = nil
		assert_not @callout.valid?
	end
	
	test "Callout - conversation should be present" do
		@callout.conversation = nil
		assert_not @callout.valid?
	end
end
