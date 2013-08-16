class UsersController < ApplicationController
  skip_before_action :ensure_authenticated
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      authenticate @user
      redirect_to root_url, notice: "Thank you for signing up!"
    else
      render "new"
    end
  end
  
  private
    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end
end
