class CreateTask
  def initialize(params)
    @params = params.merge(completed: false)
  end
  
  def run
    task = TaskPositionService.append(Task.create!(@params))
    task.save!
    task
  end
end
