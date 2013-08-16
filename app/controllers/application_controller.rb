class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  include ExhibitsHelper
  include ResultTellerHelper
  include TransactionalHelper
  include BusinessServiceCallHelper
  
  before_action :authorize
  
  private
    def current_user
      @current_user ||= User.find_by(auth_token: cookies.signed[:auth_token]) if cookies[:auth_token]
    end
    helper_method :current_user
    
    def authorize
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
end
