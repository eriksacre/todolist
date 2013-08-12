module TasksHelper
  def task_id(task)
    "t#{task.id}"
  end
  
  def label_for(task)
  	label_tag task_id(task), task.title
  end
  
  def checkbox_for_task(task, path)
  	check_box_tag task_id(task), "1", task.completed, data: { url: path }, class: 'todo'
  end
end
