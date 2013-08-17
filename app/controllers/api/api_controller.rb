module Api
  class ApiController < ApplicationController
    skip_before_action :ensure_authenticated
    before_action :authenticate_by_token
    
    private
      def authenticate_by_token
        authenticate_or_request_with_http_basic('Api') do |username, password|
          @current_user = User.find_by api_token: username
        end
      end
    
      def current_user
        @current_user
      end
      helper_method :current_user

      rescue_from Exception do |exception|
        @exception = exception
        render "error", status: :unprocessable_entity
      end
  end
end
