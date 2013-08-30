class String
  def slug
    result = self.parameterize.slice(0, 30)
    last_dash = result.rindex('-')
    last_dash && last_dash > 20 ? "-#{result.slice(0, last_dash)}" : "-#{result}"
  end
end
