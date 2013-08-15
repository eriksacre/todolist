class TasksController < ApplicationController
  def index
    @task_list = e TaskList.new
  end
  
  def create
    @task = bc :create_task, title
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
end
