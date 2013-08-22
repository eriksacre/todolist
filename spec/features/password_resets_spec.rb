require 'spec_helper'

feature "PasswordResets" do
  it "emails user when requesting password reset" do
    user = FactoryGirl.create(:user)
    visit login_path
    click_link "password"
    fill_in "Email", :with => user.email
    click_button "Reset Password"
    expect(page).to have_content("Email sent")
    expect(last_email.to).to include(user.email)
  end
  
  it "does not email invalid user when requesting password reset" do
    visit login_path
    click_link "password"
    fill_in "Email", :with => "madeupuser@example.com"
    click_button "Reset Password"
    expect(page).to have_content("Email sent")
    expect(last_email).to be_nil
  end
end
