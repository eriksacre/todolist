require "interactor_base"
require "task_policies/repositionable_task_policy"

module TaskInteractors
  class UpdateTaskPosition < InteractorBase
    dependencies :task, :task_position_service
    
    def initialize(id, new_position)
      @id = id
      @new_position = new_position
    end
  
    def run
      task.find(@id).tap do |task|
        TaskPolicies::RepositionableTaskPolicy.new(task).enforce
        task_position_service.move(task, @new_position)
        task.save!
      end
    end
  end
end