class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
  
  include ExhibitsHelper
  include ResultTellerHelper
  include TransactionalHelper
  include BusinessServiceCallHelper
  include AuthenticationHelper
  
  before_action :ensure_authenticated
  helper_method :current_user
  
end
