class TaskList
  def todo
    @todo ||= Task.todo
    @todo
  end
  
  def completed
    @completed ||= Task.completed
    @completed
  end
  
  def limited_completed
    @limited ||= Task.limited_completed
  end
  
  def blank_task
    Task.new
  end
end
