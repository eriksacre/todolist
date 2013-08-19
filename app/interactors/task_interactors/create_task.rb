module TaskInteractors
  class CreateTask
    def initialize(title)
      @title = title
    end
  
    def run
      Task.new.tap do |task|
        task.title = @title
        task.completed = false
        TaskPositionService.append(task)
        task.save!
      end
    end
  end
end