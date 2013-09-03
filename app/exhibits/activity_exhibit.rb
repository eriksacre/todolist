class ActivityExhibit < Exhibit
  def self.applicable_to?(object)
    object.is_a?(Activity)
  end
  
  def activity_info
    @activity_info ||= JSON.parse(info)
  end
  
  def title
    activity_info["related_objects"][0]["title"]
  end
  
  ACTION_TEXT = {
    "TaskInteractors::CreateTask" => "created",
    "TaskInteractors::UpdateTask" => "updated",
    "TaskInteractors::CompleteTask" => "completed",
    "TaskInteractors::ReopenTask" => "reopened",
    "TaskInteractors::UpdateTaskPosition" => "repositioned",
    "TaskInteractors::DeleteTask" => "deleted"
  }
  
  def action_text
    # TODO: Refactor so text is not hard-coded for all possible interactors over here
    # But implementing a partial per interactor is a bit much as well. Find a pragmatic solution
    ACTION_TEXT[action]
  end
  
  # TODO: Make this dynamic, instead of hardcoding all possible resource types in here
  API_PATH = {
    "Task" => ->(id, ctx) { ctx.api_v1_task_url(id) }
  }
  
  def api_url
    id = @activity_info["related_objects"][0]["id"]
    type = @activity_info["related_objects"][0]["type"]
    
    API_PATH[type].call(id, @context) + title.slug
  end
  
  def render(template)
    template.render partial: "activities/activity", locals: { activity: self }
  end
end
