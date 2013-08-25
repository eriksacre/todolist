require "interactor_base"

module TaskInteractors
  class DeleteTask < InteractorBase
    dependencies :task, :task_position_service
    
    def initialize(task_id)
      @task_id = task_id
    end
  
    def run
      task.find(@task_id).tap do |task|
        task_position_service.remove(task) if !task.position.nil?
        task.destroy
      end
    end
  end
end