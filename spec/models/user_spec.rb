require 'spec_helper'

# It would be desirable to get to the following:
# require 'active_record_spec_helper'
# require 'factories'
# require 'user'
#
# This would only load ActiveRecord for this spec, instead of the full Rails environment

describe User do
  describe "#send_password_reset" do
    let(:user) { FactoryGirl.create(:user) }

    it "generates a unique password_reset_token each time" do
      user.send_password_reset
      last_token = user.password_reset_token
      user.send_password_reset
      user.password_reset_token.should_not eq(last_token)
    end

    it "saves the time the password reset was sent" do
      user.send_password_reset
      user.reload.password_reset_sent_at.should be_present
    end

    it "delivers email to user" do
      user.send_password_reset
      last_email.to.should include (user.email)
    end
  end
end