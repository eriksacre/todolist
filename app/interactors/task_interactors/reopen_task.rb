require "interactor_base"
require "task_policies/reopenable_task_policy"

module TaskInteractors
  class ReopenTask < InteractorBase
    dependencies :task, :task_position_service
    
    def initialize(current_user, task_id)
      super current_user
      @task_id = task_id
    end
  
    def perform
      task.find(@task_id).tap do |task|
        TaskPolicies::ReopenableTaskPolicy.new(task).enforce
        task_position_service.append(task)
        task.completed = false
        task.save!
      end
    end
  end
end