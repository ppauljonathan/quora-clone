require "test_helper"

class UserMailerTest < ActionMailer::TestCase
  test "verification_email" do
    mail = UserMailer.verification_email
    assert_equal "Verification email", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
