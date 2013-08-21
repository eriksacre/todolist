class CompleteTaskExhibit < TaskExhibit
  def self.applicable_to?(object)
    object.is_a?(Task) && object.completed
  end
  
  # def to_partial_path
  #   "/tasks/complete_task"
  # end
  
  def completed_at_for_user
    completed_at.strftime('%-d %b')
  end

  def render(template)
    template.render partial: "tasks/complete_task", locals: { task: self }
  end
end
