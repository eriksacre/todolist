module TaskInteractors
  class CreateTask
    def initialize(title)
      @title = title
    end
  
    def run
      # ActiveRecord will catch this error.
      # However, putting it here makes it an explicit part of this interactor.
      # TODO: make a decision on how to handle this.
      # raise ArgumentError.new("Title can't be blank") if @title.nil? || @title == ""
      
      Task.new.tap do |task|
        task.title = @title
        task.completed = false
        TaskPositionService.append(task)
        task.save!
      end
    end
  end
end