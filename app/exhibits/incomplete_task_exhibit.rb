class IncompleteTaskExhibit < Exhibit
  def self.applicable_to?(object)
    object.is_a?(Task) && !object.completed
  end
  
  def to_partial_path
    "/tasks/incomplete_task"
  end

  # def render(template)
  #   template.render partial: "tasks/incomplete_task", locals: { task: self }
  # end
end
