require 'test_helper'

class ProfileTest < ActiveSupport::TestCase
	def setup
		@profile = Profile.new(description: "description")
	end
	
	test "Profile - should be valid" do
		assert @profile.valid?
	end
	
	test "Profile - description should be valid" do
		@profile.description = nil
		assert_not @profile.valid?
	end
end
