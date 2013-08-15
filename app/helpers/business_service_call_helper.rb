module BusinessServiceCallHelper
  def business_service_call(service_class, *params)
    service_object = service_class.to_s.classify.constantize.new *params
    exhibit(result_teller(transactional(service_object), self).run)
  end
  
  alias :bc :business_service_call
end
