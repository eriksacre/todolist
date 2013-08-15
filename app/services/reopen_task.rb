class ReopenTask
  def initialize(task_id)
    @task_id = task_id
  end
  
  def run
    Task.find(@task_id).tap do |task|
      TaskPositionService.append(task)
      task.completed = false
      task.save!
    end
  end
end
