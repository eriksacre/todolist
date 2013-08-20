module JsonHelpers
  def json
    @json ||= JSON.parse(response.body)
  end
  
  def json_api
    @env ||= {}
    @env['Content-Type'] = 'application/json'
    @env['Accept'] = 'application/json'
  end
end