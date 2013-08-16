module AuthenticationHelper
  def current_user
    @current_user ||= User.find_by(auth_token: cookies.signed[:auth_token]) if cookies[:auth_token]
  end
  
  def ensure_authenticated
    redirect_to_login if current_user.nil?
  end
  
  def redirect_to_login
    if request.xhr?
      # It would be nicer for the user if we sent an Ajax login form
      # so the user would remain on the current screen.
      render js: "alert('Your session expired. Please login to continue working.'); window.location.href = '#{root_url}';"
    else
      path = login_url + "?return=" + CGI.escape(request.original_fullpath)
      redirect_to path, alert: "You must be logged in to access that page"
    end
  end
  
  def authenticate(user, permanent = false)
    if permanent
      cookies.permanent.signed[:auth_token] = user.auth_token
    else
      cookies.signed[:auth_token] = user.auth_token
    end
  end
  
  def invalidate_authentication
    cookies.delete(:auth_token)
  end
end
