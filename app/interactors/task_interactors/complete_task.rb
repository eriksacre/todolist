require 'interactor_base'
require "task_policies/completable_task_policy"

module TaskInteractors
  class CompleteTask < InteractorBase
    dependencies :task, :time, :task_position_service
    
    def initialize(current_user, task_id)
      super current_user
      @task_id = task_id
    end
  
    def perform
      task.find(@task_id).tap do |task|
        TaskPolicies::CompletableTaskPolicy.new(task).enforce
        task_position_service.remove(task)
        task.completed = true
        task.completed_at = time.zone.now
        task.save!
      end
    end
  end
end