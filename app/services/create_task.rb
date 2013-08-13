class CreateTask
  def initialize(title)
    @title = title
  end
  
  def run
    Task.create! do |task|
      task.title = @title
      task.completed = false
      TaskPositionService.append(task)
    end
  end
end
