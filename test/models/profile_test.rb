require 'test_helper'

class ProfileTest < ActiveSupport::TestCase
	def setup
		@profile = Profile.new(description: "description")
	end
	
	test "Profile - should be valid" do
		assert @profile.valid?
	end
	
	test "Profile - description should be present" do
		@profile.description = nil
		assert_not @profile.valid?
	end
	
	test "Profile - description should not be blank" do
		@profile.description = ""
		assert_not @profile.valid?
	end
	
	test "Profile - description should be unique" do
		@profile2 = Profile.new(description: "description")
		assert_not @profile2.valid?
	end
end
