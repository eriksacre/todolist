require 'interactor_base'

module TaskInteractors
  class CreateTask < InteractorBase
    dependencies :task, :task_position_service
    
    def initialize(current_user, title)
      super(current_user)
      @title = title
    end
  
    def perform
      # ActiveRecord will catch this error.
      # However, putting it here makes it an explicit part of this interactor.
      # TODO: make a decision on how to handle this.
      # raise ArgumentError.new("Title can't be blank") if @title.nil? || @title == ""
      
      task.new.tap do |task|
        track task, :title
        task.title = @title
        task.completed = false
        task_position_service.append(task)
        task.save!
      end
    end
  end
end