class DeleteTask
  def initialize(task_id)
    @task_id = task_id
  end
  
  def run
    TaskPositionService.remove(Task.find(@task_id)).save!
    Task.destroy(@task_id)
  end
end
