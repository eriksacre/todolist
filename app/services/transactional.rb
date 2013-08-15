class Transactional < SimpleDelegator
  def run
    ActiveRecord::Base.transaction do
      super
    end
  end
end
