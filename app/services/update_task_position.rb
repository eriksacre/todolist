class UpdateTaskPosition
  def initialize(id, params)
    @id = id
    @params = params
  end
  
  def run
    task = TaskPositionService.move(Task.find(@id), @params[:position])
    task.save!
    task
  end
end