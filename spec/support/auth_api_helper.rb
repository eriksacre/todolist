module AuthApiHelper
  #
  # pass the @env along with your request, eg:
  #
  # GET '/labels', {}, @env
  #
  def http_authenticate(username, password)
    @env ||= {}
    @env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(username,password)
  end
  
  def http_authenticate_by_token(token)
    http_authenticate(token, "x")
  end
end