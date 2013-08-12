class TaskCompleted
  def initialize(task_id)
    @task = Task.find(task_id)
  end
  
  def run
    TaskPositionService.remove(@task)
    @task.completed = true
    @task.save!
    @task
  end
end
