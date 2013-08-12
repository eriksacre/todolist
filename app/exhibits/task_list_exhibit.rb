class TaskListExhibit < Exhibit
  exhibit_query :todo, :completed, :blank_task
  
  def self.applicable_to?(object)
    object.is_a?(TaskList)
  end
  
  def to_partial_path
    "/tasks/task_list"
  end
end