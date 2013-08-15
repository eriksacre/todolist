class TasksController < ApplicationController
  def index
    @task_list = exhibit(TaskList.new)
  end
  
  def create
    @task = exhibit(transactional(CreateTask.new(title)).run)
  end
  
  def destroy
    @task = exhibit(transactional(DeleteTask.new(task_id)).run)
  end
  
  def edit
    @task = exhibit(Task.find(task_id))
  end
  
  def update
    @task = exhibit(transactional(UpdateTask.new(task_id, title)).run)
    render "show"
  end
  
  def show
    @task = exhibit(Task.find(task_id))
  end
  
  def reposition
    @task = exhibit(transactional(UpdateTaskPosition.new(task_id, position)).run)
  end
  
  def complete
    @task = exhibit(transactional(CompleteTask.new(task_id)).run)
  end
  
  def reopen
    @task = exhibit(transactional(ReopenTask.new(task_id)).run)
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
end
