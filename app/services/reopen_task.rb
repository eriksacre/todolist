class ReopenTask
  def initialize(task_id)
    @task_id = task_id
  end
  
  def run
    task = Task.find(@task_id)
    TaskPositionService.append(task)
    task.completed = false
    task.save!
    task
  end
end
