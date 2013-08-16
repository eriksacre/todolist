module BusinessServiceCallHelper
  def business_service_call(service_class, *params)
    object = service_object service_class, *params
    exhibit(result_teller(transactional(object), self).run)
  end
  alias :bc :business_service_call
  
  def api_service_call(service_class, *params)
    object = service_object service_class, *params
    transactional(object).run
  end
  alias :ac :api_service_call
  
  def service_object(service_class, *params)
    service_class.to_s.classify.constantize.new *params
  end
end
