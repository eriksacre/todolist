class TasksController < ApplicationController
  def index
    @task_list = e TaskList.new
  end
  
  def create
    begin
      @task = bc :create_task, title
    rescue ActiveRecord::RecordInvalid => e
      # Why exceptions instead of checking return value?
      # Because transactions need the exception to rollback
      # Exception local to create
      # Response can be very specific
      @errors = e.record.errors
      render template: "tasks/error"
    end
  end
  
  def destroy
    @task = bc :delete_task, task_id
  end
  
  def edit
    @task = e Task.find(task_id)
  end
  
  def update
    @task = bc :update_task, task_id, title
    render "show"
  end
  
  def show
    @task = e Task.find(task_id)
  end
  
  def reposition
    @task = bc :update_task_position, task_id, position
  end
  
  def complete
    @task = bc :complete_task, task_id
  end
  
  def reopen
    @task = bc :reopen_task, task_id
  end
  
  private
    def task_id
      params[:id].to_i
    end
    
    def title
      params[:task][:title]
    end

    def position
      params[:task][:position].to_i
    end

    # Global catch for all controller methods
    # Works if app has some centralized response to errors
    rescue_from ActiveRecord::RecordInvalid do |exception|
      @errors = exception.record.errors
      render template: "tasks/error"
    end
end
