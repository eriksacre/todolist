class ResultTeller < BusinessDelegator
  def initialize(delegated_object, caller)
    raise ArgumentError.new("Caller cannot be nil") if caller.nil?
    @caller = caller
    super delegated_object
  end
  
  def run
    begin
      tell_caller_about_success super
    rescue Exception => e
      tell_caller_about e
    end
  end
  
  private
    def tell_caller(method_suffix, value)
      method = (delegated_class.name.underscore + method_suffix).to_sym
      @caller.send method, value if @caller.respond_to? method, true
      value
    end
    
    def tell_caller_about_success(return_value)
      tell_caller "_succeeded", return_value
    end
    
    def tell_caller_about(exception)
      tell_caller "_failed", exception
    end
end