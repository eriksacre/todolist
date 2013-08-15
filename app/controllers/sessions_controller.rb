class SessionsController < ApplicationController
  skip_before_action :authorize
  
  def new
  end

  def create
    user = User.find_by email: params[:email]
    if user && user.authenticate(params[:password])
      reset_session # Mitigate fixation attack
      session[:user_id] = user.id
      redirect_to root_url, notice: "Logged in!"
    else
      flash.now.alert = "Email or password is invalid."
      render "new"
    end
  end
  
  def destroy
    session[:user_id] = nil
    reset_session
    redirect_to login_path, notice: "Logged out!"
  end
end
