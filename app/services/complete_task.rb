class CompleteTask
  def initialize(task_id)
    @task_id = task_id
  end
  
  def run
    Task.find(@task_id).tap do |task|
      # May only happen if not yet completed
      TaskPositionService.remove(task)
      task.completed = true
      task.save!
    end
  end
end
