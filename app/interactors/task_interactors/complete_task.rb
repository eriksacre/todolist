module TaskInteractors
  class CompleteTask
    def initialize(task_id)
      @task_id = task_id
    end
  
    def run
      Task.find(@task_id).tap do |task|
        raise ArgumentError.new("Task is already completed") if task.completed
        TaskPositionService.remove(task)
        task.completed = true
        task.completed_at = Time.zone.now
        task.save!
      end
    end
  end
end