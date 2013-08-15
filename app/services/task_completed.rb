class TaskCompleted
  def initialize(task_id)
    @task_id = task_id
  end
  
  def run
    task = Task.find(@task_id)
    TaskPositionService.remove(task)
    task.completed = true
    task.save!
    task
  end
end
