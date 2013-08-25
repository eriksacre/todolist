require "policy_base"

module TaskPolicies
  class CompletableTaskPolicy < PolicyBase
    def initialize(task)
      @task = task
    end
    
    def comply?
      !@task.completed
    end
    
    def description
      "Task is already completed"
    end
  end
end