module TaskInteractors
  class UpdateTask
    def initialize(task_id, title)
      @task_id = task_id
      @title = title
    end
  
    def run
      Task.find(@task_id).tap do |task|
        raise ArgumentError.new('Cannot modify completed task') if task.completed
        task.title = @title
        task.save!
      end
    end
  end
end