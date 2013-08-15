class UpdateTaskPosition
  def initialize(id, new_position)
    @id = id
    @new_position = new_position
  end
  
  def run
    Task.find(@id).tap do |task|
      TaskPositionService.move(task, @new_position)
      task.save!
    end
  end
end