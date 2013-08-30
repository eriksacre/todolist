# The current implementation does not support a scope, so the position is global to the table

class TaskPositionService
  class << self
    
    def append(task)
      task.position = highest_position + 1
      task
    end
    
    def remove(task)
      update_positions first: task.position, last: highest_position, op: :neg
      task.position = nil
      task
    end
    
    def move(task, new_position)
      old_position = task.position
      reposition_other_tasks old_position, new_position
      task.position = new_position
      task      
    end

    private
      def reposition_other_tasks(old_position, new_position)
        update_positions first: old_position + 1, last: new_position, op: :neg if old_position < new_position
        update_positions first: new_position, last: old_position - 1, op: :pos if old_position > new_position
      end
  
      def highest_position
        Task.maximum(:position) || -1
      end
  
      def update_positions options
        sign = options[:op] == :pos ? '+' : '-'
        Task.where("position >= ? and position <= ?", options[:first], options[:last]).update_all("position = position #{sign} 1")
      end
  end
end
