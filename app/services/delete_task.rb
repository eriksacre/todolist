class DeleteTask
  def initialize(task_id)
    @task_id = task_id
  end
  
  def run
    Task.find(@task_id).tap do |task|
      TaskPositionService.remove(task) if !task.position.nil?
      task.destroy
    end
  end
end
