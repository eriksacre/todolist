class UserMailer < ActionMailer::Base
  default from: "no-reply@todolist.dev"

  def password_reset(user)
    @user = user
    mail :to => user.email, :subject => "Todo-list: Password reset"
  end
end
