class ReopenTask
  def initialize(task_id)
    @task = Task.find(task_id)
  end
  
  def run
    TaskPositionService.append(@task)
    @task.completed = false
    @task.save!
    @task
  end
end
