require 'active_record_spec_helper'
require 'factories/factories'
require 'user'

describe User do
  describe "#send_password_reset" do
    let(:user) { FactoryGirl.create(:user) }

    before :each do
      # The following should be improved upon. I'm mocking and stubbing
      # away dependencies on ActiveSupport and ActiveMailer,
      # but in the process this spec needs to know too much about User's
      # internals.
      Time.stub(:zone).and_return(Time)
      
      mailer = Class.new
      stub_const('Mailer', mailer)
      mailer.should_receive(:deliver).at_least(1).times
      
      user_mailer = Class.new
      stub_const('UserMailer', user_mailer)
      user_mailer.should_receive(:password_reset).at_least(1).times.with(user).and_return(mailer)
    end
    
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
      # Tested by means of user_mailer.should_receive...
    end
  end
end