class TasksController < ApplicationController
  interactor_namespace :task

  def index
    @task_list = e TaskListViewModel.new
  end
  
  def completed
    @completed = e Task.completed
  end
  
  def create
    bc :create_task, title
  end
  
  def create_task_succeeded(task)
    @task = e task
    render "create"
  end
  
  def create_task_failed(exception)
    raise exception if !exception.is_a?(ActiveRecord::RecordInvalid) # TODO: Refactor
    @errors = exception.record.errors
    render template: "tasks/error"
  end
  
  private :create_task_succeeded, :create_task_failed
  
  def destroy
    @task = bc :delete_task, params_id
  end
  
  def edit
    @task = e Task.find(params_id)
    TaskPolicies::ModifyableTaskPolicy.new(@task).enforce
  end
  
  def update
    bc :update_task, params_id, title
  end
  
  def update_task_succeeded(task)
    @task = e task
    render "show"
  end
  
  def update_task_failed(exception)
    raise exception if !exception.is_a?(ActiveRecord::RecordInvalid) # TODO: Refactor
    @task = e exception.record
    render "edit"
  end
  
  private :update_task_succeeded, :update_task_failed
  
  def show
    @task = e Task.find(params_id)
  end
  
  def reposition
    @task = bc :update_task_position, params_id, position
    render "show"
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
