require "policy_base"

module TaskPolicies
  class ModifyableTaskPolicy < PolicyBase
    def initialize(task)
      @task = task
    end
    
    def comply?
      # This is the key element of a policy: the condition
      # This example is trivial, but the condition could
      # be much more involved.
      !@task.completed
    end
    
    def description
      "Cannot modify completed task"
    end
  end
end