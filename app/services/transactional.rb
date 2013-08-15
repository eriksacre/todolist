class Transactional < BusinessDelegator
  def run
    ActiveRecord::Base.transaction do
      super
    end
  end
end
