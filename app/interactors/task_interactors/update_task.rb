require 'interactor_base'
require "task_policies/modifyable_task_policy"

module TaskInteractors
  class UpdateTask < InteractorBase
    dependencies :task
    
    def initialize(task_id, title)
      @task_id = task_id
      @title = title
    end
  
    def run
      task.find(@task_id).tap do |task|
        TaskPolicies::ModifyableTaskPolicy.new(task).enforce
        task.title = @title
        task.save!
      end
    end
  end
end