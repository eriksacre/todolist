class TaskListExhibit < Exhibit
  exhibit_query :todo, :completed, :limited_completed, :blank_task
  
  def self.applicable_to?(object)
    object.is_a?(TaskList)
  end
  
  def show_more(context)
    return if !Task.more?
    context.content_tag :li, id: 'show-more' do
      context.link_to "Show more", context.completed_tasks_path, remote: true
    end
  end
  
  def to_partial_path
    "/tasks/task_list"
  end
end