class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
  
  include ExhibitsHelper
  include TransactionalHelper
  include BusinessServiceCallHelper
  include BusinessMethodDetectionHelper
  include AuthenticationHelper
  
  before_action :ensure_authenticated
  helper_method :current_user

  private
    def params_id
      params[:id].to_i
    end
end
