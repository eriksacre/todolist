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
    "#{interactor.to_s}_interactors/#{service_class.to_s}".camelize.constantize.new *params
  end

  module ClassMethods
    def interactor(namespace)
      define_method(:interactor) do
        namespace
      end
    end
  end
  
  def self.included(base)
    base.extend(ClassMethods)
  end
end
