require "policy_base"

module TaskPolicies
  class RepositionableTaskPolicy < PolicyBase
    def initialize(task)
      @task = task
    end
    
    def comply?
      !@task.completed
    end
    
    def description
      "A completed task does not have a position"
    end
  end
end
