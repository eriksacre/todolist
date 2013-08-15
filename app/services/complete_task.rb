class CompleteTask
  def initialize(task_id)
    @task_id = task_id
  end
  
  def run
    Task.find(@task_id).tap do |task|
      TaskPositionService.remove(task)
      task.completed = true
      task.save!
    end
  end
end
