class UpdateTask
  def initialize(task_id, title)
    @task_id = task_id
    @title = title
  end
  
  def run
    task = Task.find(@task_id)
    task.title = @title
    task.save!
    task
  end
end