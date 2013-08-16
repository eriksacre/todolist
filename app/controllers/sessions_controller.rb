class SessionsController < ApplicationController
  skip_before_action :authorize
  
  def new
    return redirect_to root_url, notice: "You are already logged in" if current_user
    @return = params[:return]
  end

  def create
    user = User.find_by email: params[:email]
    if user && user.authenticate(params[:password])
      if params[:remember_me]
        cookies.permanent.signed[:auth_token] = user.auth_token
      else
        cookies.signed[:auth_token] = user.auth_token
      end
      redirect_to params[:return], notice: "Logged in!"
    else
      flash.now.alert = "Email or password is invalid."
      render "new"
    end
  end
  
  def destroy
    cookies.delete(:auth_token)
    redirect_to login_path, notice: "Logged out!"
  end
end
