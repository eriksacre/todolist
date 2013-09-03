require 'interactor_base'
require "task_policies/modifyable_task_policy"

module TaskInteractors
  class UpdateTask < InteractorBase
    dependencies :task
    
    def initialize(current_user, task_id, title)
      super current_user
      @task_id = task_id
      @title = title
    end
  
    def perform
      task.find(@task_id).tap do |task|
        TaskPolicies::ModifyableTaskPolicy.new(task).enforce
        track task, :title
        task.title = @title
        task.save!
      end
    end
  end
end