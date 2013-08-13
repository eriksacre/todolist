class TaskExhibit < Exhibit
  # This exhibit will only serve as baseclass, so it will never return true to applicable_to?
  
  def task_id(task)
    "t#{task.id}"
  end
  
  def label_for(template)
  	template.label_tag task_id(self), self.title
  end
  
  def checkbox_for_task(template, path)
  	template.check_box_tag task_id(self), "1", self.completed, data: { url: path }, class: 'todo'
  end
end
