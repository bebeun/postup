require 'test_helper'

class UserTest < ActiveSupport::TestCase
	def setup
		@user = User.new(name: "Name", email: "email@email.fr", password: "password")
		@user.profiles << Profile.new(description: "description 1")
		@user.profiles << Profile.new(description: "description 2")
	end
	
	test "User name - should be present" do
		@user.name = nil
		assert_not @user.valid?
	end
	
	test "User email - should be present" do
		@user.email = nil
		assert_not @user.valid?
	end
	
	test "User password- should be present" do
		@user.password = nil
		assert_not @user.valid?
	end
	
	test "User - should be valid" do
		assert @user.valid?
	end
	
	test "User - profile should not necessarily be present" do
		@user.profiles = Profile.none
		assert @user.valid?
	end
	
	test "User - profile description should  be present" do
		@user.profiles.first.description = nil
		assert_not @user.valid?
	end
	
end
