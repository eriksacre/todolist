class TaskList
  def todo
    @todo ||= Task.todo
    @todo
  end
  
  def completed
    @completed ||= Task.completed
    @completed
  end
end
