module Api
  module V1
    class MeController < Api::ApiController
      skip_before_action :authenticate_by_token
      before_action :authenticate_by_http_basic
  
      # When writing an interactive API client it may not make sense to
      # ask the user for the API token. Instead the client may want to prompt
      # for the email/pwd-combination. This controller represents a special resource
      # called 'me'. It uses basic authentication via the email/pwd, and returns
      # JSON containing the API-token that must be used for all other API calls.
      def index
      end
  
      private
        def authenticate_by_http_basic
          authenticate_or_request_with_http_basic('Api-client') do |email, password|
            user = User.find_by email: email
            if user && user.authenticate(password)
              @current_user = user
            else
              false
            end
          end
        end

        def current_user
          @current_user
        end
        helper_method :current_user
    end
  end
end