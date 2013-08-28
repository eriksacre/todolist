module FeatureHelpers
  def login
    @user = FactoryGirl.create(:user)
    visit login_path
    fill_in 'email', with: @user.email
    fill_in 'password', with: 'secret'
    click_button 'Log In'
    expect(page).to have_content("Logged in")
  end
end