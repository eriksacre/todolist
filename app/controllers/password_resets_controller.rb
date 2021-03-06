class PasswordResetsController < ApplicationController
  skip_before_action :ensure_authenticated

  def new
  end
  
  def create
    user = User.find_by email: params[:email]
    user.send_password_reset if user
    redirect_to login_url, :notice => "Email sent with password reset instructions."
  end
  
  def edit
    @user = User.find_by! password_reset_token: params_id
  end
  
  def update
    @user = User.find_by! password_reset_token: params_id
    if @user.password_reset_sent_at < 2.hours.ago
      redirect_to new_password_reset_path, :alert => "Password reset has expired."
    elsif @user.new_password(user_params)
      authenticate @user
      redirect_to root_url, :notice => "Password has been reset."
    else
      render :edit
    end
  end
  
  private
    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end
end
