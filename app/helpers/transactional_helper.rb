module TransactionalHelper
  def transactional(object)
    Transactional.new(object)
  end
end
