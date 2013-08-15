module ResultTellerHelper
  def result_teller(object, caller)
    ResultTeller.new object, caller
  end
end