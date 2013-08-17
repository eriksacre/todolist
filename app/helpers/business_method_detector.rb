class BusinessMethodDetector
  def self.find_business_method(params, &block)
    method = new(params)
    block.call method, params
    raise ArgumentError.new("Request did not contain a valid combination of attributes") if method.result.nil?
    method.result
  end
  
  attr_reader :result
  
  def initialize(params)
    @params = params
    @result = nil
  end
  
  def contains(*keys)
    return if @result != nil
    @result = yield if params_contain_exclusively @params, keys
  end

  def params_contain_exclusively params, keys
    key_count, keys_found = keys.length, 0
    return false if key_count != params.length
    
    keys.each do |key|
      keys_found += 1 if params.has_key?(key) # && !(params[key].is_a?(Array) || params[key].is_a?(Hash))
    end
    
    keys_found == key_count
  end
end
