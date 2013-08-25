require "policy_base"

module TaskPolicies
  class ReopenableTaskPolicy < PolicyBase
    def initialize(task)
      @task = task
    end
    
    def comply?
      @task.completed
    end
    
    def description
      "Task is already open"
    end
  end
end