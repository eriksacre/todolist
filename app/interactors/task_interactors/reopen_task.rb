module TaskInteractors
  class ReopenTask
    def initialize(task_id)
      @task_id = task_id
    end
  
    def run
      Task.find(@task_id).tap do |task|
        raise ArgumentError.new("Task is already open") if !task.completed
        TaskPositionService.append(task)
        task.completed = false
        task.save!
      end
    end
  end
end