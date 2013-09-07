class TasksController < ApplicationController
  interactor_namespace :task

  def index
    @task_list = e TaskListViewModel.new
  end
  
  def completed
    @completed = e Task.completed
  end
  
  def create
    @task = bc :create_task, title
    render "create"
  rescue ActiveRecord::RecordInvalid => exception
    @errors = exception.record.errors
    render template: "tasks/error"
  end
  
  def destroy
    @task = bc :delete_task, params_id
  end
  
  def edit
    @task = e Task.find(params_id)
    TaskPolicies::ModifyableTaskPolicy.new(@task).enforce
  end
  
  def update
    @task = bc :update_task, params_id, title
    render "show"
  rescue ActiveRecord::RecordInvalid => exception
    @task = e exception.record
    render "edit"
  end
  
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
