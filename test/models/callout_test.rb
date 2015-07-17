require 'test_helper'

class CalloutTest < ActiveSupport::TestCase
	def setup
		@creator = User.new;
		@target_user = User.new(name: "name", email: "email@email.fr", password: "password");
		@target_potential_user = PotentialUser.new;
		
		@target_user.profiles << Profile.new(description: "description 1")
		@target_potential_user.profile = Profile.new(description: "description 2")

		@conversation = Conversation.new
		
		@callout_user = Callout.new(creator: @creator, calloutable: @target_user, conversation: @conversation)
		@callout_potential_user = Callout.new(creator: @creator, calloutable: @target_potential_user, conversation: @conversation)
	end
	
	test "Callout to User - should be valid" do
		assert @callout_user.valid?
	end
	
	test "Callout to User - creator should be present" do
		@callout_user.creator = nil
		assert_not @callout_user.valid?
	end
	
	test "Callout to User - calloutable should be present" do
		@callout_user.calloutable = nil
		assert_not @callout_user.valid?
	end
	
	test "Callout to User - conversation should be present" do
		@callout_user.conversation = nil
		assert_not @callout_user.valid?
	end
	
	test "Callout to User - User name should be present" do
		@callout_user.calloutable.name = nil
		assert_not @callout_user.valid?
	end
	
	test "Callout to User - User email should be present" do
		@callout_user.calloutable.email = nil
		assert_not @callout_user.valid?
	end
	
	test "Callout to User - User password should be present" do
		@callout_user.calloutable.password = nil
		assert_not @callout_user.valid?
	end
	
	test "Callout to PotentialUser - should be valid" do
		assert @callout_potential_user.valid?
	end
	
	test "Callout to PotentialUser - creator should be present" do
		@callout_potential_user.creator = nil
		assert_not @callout_potential_user.valid?
	end
	
	test "Callout to PotentialUser - calloutable should be present" do
		@callout_potential_user.calloutable = nil
		assert_not @callout_potential_user.valid?
	end
	
	test "Callout to PotentialUser - conversation should be present" do
		@callout_potential_user.conversation = nil
		assert_not @callout_potential_user.valid?
	end
	
	test "Callout to PotentialUser - PotentialUser profile should be present" do
		@callout_potential_user.calloutable.profile = nil
		assert_not @callout_potential_user.valid?
	end
	
	test "Callout to PotentialUser - PotentialUser profile description should be present" do
		@callout_potential_user.calloutable.profile.description = nil
		assert_not @callout_potential_user.valid?
	end
end
