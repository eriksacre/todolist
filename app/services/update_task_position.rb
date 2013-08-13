class UpdateTaskPosition
  def initialize(id, new_position)
    @id = id
    @new_position = new_position
  end
  
  def run
    task = TaskPositionService.move(Task.find(@id), @new_position)
    task.save!
    task
  end
end