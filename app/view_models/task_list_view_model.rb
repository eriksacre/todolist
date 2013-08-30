class TaskListViewModel
  MAX_COMPLETED = 3
  
  def todo
    @todo ||= Task.todo
  end
  
  def completed
    @completed ||= Task.completed
  end
  
  def limited_completed
    @limited ||= Task.limited_completed(MAX_COMPLETED)
  end
  
  def blank_task
    Task.new
  end
end
