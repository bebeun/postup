require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test "facebook_activation" do
    mail = UserMailer.facebook_activation
    assert_equal "Facebook activation", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
