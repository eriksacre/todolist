class TaskListViewModel
  def todo
    @todo ||= Task.todo
  end
  
  def completed
    @completed ||= Task.completed
  end
  
  def limited_completed
    @limited ||= Task.limited_completed
  end
  
  def blank_task
    Task.new
  end
end
