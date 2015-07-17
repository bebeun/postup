require 'test_helper'

class PotentialUserTest < ActiveSupport::TestCase
	def setup
		@potential_user = PotentialUser.new()
		@potential_user.profile = Profile.new(description: "description")
	end
	
	test "PotentialUser - should be valid" do
		assert @potential_user.valid?
	end
	
	test "PotentialUser - profile should be present" do
		@potential_user.profile = nil
		assert_not @potential_user.valid?
	end
	
	test "PotentialUser - profile description should be present" do
		@potential_user.profile.description = nil
		assert_not @potential_user.valid?
	end
end
