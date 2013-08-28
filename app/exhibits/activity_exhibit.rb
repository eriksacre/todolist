class ActivityExhibit < Exhibit
  def self.applicable_to?(object)
    object.is_a?(Activity)
  end
  
  def title
    activity_info = JSON.parse(info)
    activity_info["related_objects"][0]["title"]
  end
  
  ACTION_TEXT = {
    "TaskInteractors::CreateTask" => "created",
    "TaskInteractors::UpdateTask" => "updated",
    "TaskInteractors::CompleteTask" => "completed",
    "TaskInteractors::ReopenTask" => "reopened",
    "TaskInteractors::UpdateTaskPosition" => "position updated",
    "TaskInteractors::DeleteTask" => "deleted"
  }
  
  def action_text
    # TODO: Refactor so text is not hard-coded for all possible interactors over here
    # But implementing a partial per interactor is a bit much as well. Find a pragmatic solution
    ACTION_TEXT[action]
  end
  
  def render(template)
    template.render partial: "activities/activity", locals: { activity: self }
  end
end
