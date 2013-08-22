require 'interactor_base'

module TaskInteractors
  class CompleteTask < InteractorBase
    dependencies :task, :time, :task_position_service
    
    def initialize(task_id)
      @task_id = task_id
    end
  
    def run
      task.find(@task_id).tap do |task|
        raise ArgumentError.new("Task is already completed") if task.completed
        task_position_service.remove(task)
        task.completed = true
        task.completed_at = time.zone.now
        task.save!
      end
    end
  end
end