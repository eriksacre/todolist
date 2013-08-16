class SessionsController < ApplicationController
  skip_before_action :ensure_authenticated
  
  def new
    return redirect_to root_url, notice: "You are already logged in" if current_user
    @return = params[:return]
  end

  def create
    user = User.find_by email: params[:email]
    if user && user.authenticate(params[:password])
      authenticate user, params[:remember_me]
      redirect_to params[:return], notice: "Logged in!"
    else
      flash.now.alert = "Email or password is invalid."
      render "new"
    end
  end
  
  def destroy
    invalidate_authentication
    redirect_to login_path, notice: "Logged out!"
  end
end
