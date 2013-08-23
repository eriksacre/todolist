class TasksController < ApplicationController
  interactor_namespace :task
  
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
    @task = bc :delete_task, params_id
  end
  
  def edit
    @task = e Task.find(params_id)
  end
  
  def update
    bc :update_task, params_id, title
  end
  
  def update_task_succeeded(task)
    @task = e task
    render "show"
  end
  
  def update_task_failed(exception)
    @task = e exception.record
    render "edit"
  end
  
  private :update_task_succeeded, :update_task_failed
  
  def show
    @task = e Task.find(params_id)
  end
  
  def reposition
    @task = bc :update_task_position, params_id, position
  end
  
  def complete
    @task = bc :complete_task, params_id
  end
  
  def reopen
    @task = bc :reopen_task, params_id
  end
  
  private
    def title
      params[:task][:title]
    end

    def position
      params[:task][:position].to_i
    end

    # Global catch for all controller methods
    # Works if app has some centralized response to errors
    rescue_from ActiveRecord::RecordNotFound do |exception|
      error = exception.message
      render  js: "alert(\"#{error}\"); window.location.reload();"
    end

    # Handle business method problems. The cause is often concurrency
    rescue_from ArgumentError do |exception|
      error = exception.message
      render js: "alert(\"#{error}\"); window.location.reload();"
    end
end
