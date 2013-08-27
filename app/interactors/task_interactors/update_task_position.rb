require "interactor_base"
require "task_policies/repositionable_task_policy"

module TaskInteractors
  class UpdateTaskPosition < InteractorBase
    dependencies :task, :task_position_service
    
    def initialize(current_user, id, new_position)
      super current_user
      @id = id
      @new_position = new_position
    end
  
    def perform
      task.find(@id).tap do |task|
        TaskPolicies::RepositionableTaskPolicy.new(task).enforce
        @old_position = task.position # TODO: Refactor
        task_position_service.move(task, @new_position)
        task.save!
      end
    end
    
    def log_specifics activity, task
      activity.add_parameter :position, @old_position, @new_position
    end
  end
end