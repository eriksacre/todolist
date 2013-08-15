class BusinessDelegator < SimpleDelegator
  def delegated_class
    klass = __getobj__.class
    klass < BusinessDelegator ? __getobj__.delegated_class : klass
  end
end