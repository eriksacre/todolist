class CompleteTaskExhibit < Exhibit
  def self.applicable_to?(object)
    object.is_a?(Task) && object.completed
  end
  
  # def to_partial_path
  #   "/tasks/complete_task"
  # end
  
  def updated_at_for_user
    updated_at.strftime('%-d %b')
  end

  def render(template)
    template.render partial: "tasks/complete_task", locals: { task: self }
  end
end
