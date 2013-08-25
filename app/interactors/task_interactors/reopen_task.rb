require "interactor_base"
require "task_policies/reopenable_task_policy"

module TaskInteractors
  class ReopenTask < InteractorBase
    dependencies :task, :task_position_service
    
    def initialize(task_id)
      @task_id = task_id
    end
  
    def run
      task.find(@task_id).tap do |task|
        TaskPolicies::ReopenableTaskPolicy.new(task).enforce
        task_position_service.append(task)
        task.completed = false
        task.save!
      end
    end
  end
end