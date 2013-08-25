class PolicyBase
  def enforce
    raise ArgumentError.new(description) if !comply?
  end
end