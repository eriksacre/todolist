class TasksController < ApplicationController
  def index
    @task_list = exhibit(TaskList.new)
  end
  
  def create
    @task = exhibit(CreateTask.new(task_params).run)
  end
  
  def destroy
    @task = DeleteTask.new(params[:id]).run
  end
  
  def update
    @task = UpdateTaskPosition.new(params[:id], task_position_params).run
  end
  
  def complete
    @task = exhibit(TaskCompleted.new(params[:id]).run)
  end
  
  def reopen
    @task = exhibit(ReopenTask.new(params[:id]).run)
  end
  
  private
    def task_params
      params.require(:task).permit(:title)
    end
    
    def task_position_params
      params.require(:task).permit(:position)
    end
end
