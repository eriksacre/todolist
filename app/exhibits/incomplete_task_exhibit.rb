class IncompleteTaskExhibit < TaskExhibit
  def self.applicable_to?(object)
    object.is_a?(Task) && !object.completed
  end
  
  # def to_partial_path
  #   "/tasks/incomplete_task"
  # end
  
  def cancel(template)
    if new_record?
      template.link_to "I'm done adding tasks", '#', id: 'cancel-task-form'
    else
      template.link_to "Cancel", template.task_path(self), remote: true
    end
  end
  
  def render(template)
    template.render partial: "tasks/incomplete_task", locals: { task: self }
  end
end
