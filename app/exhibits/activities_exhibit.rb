class ActivitiesExhibit < Exhibit
  exhibit_query :activities
  
  def self.applicable_to?(object)
    object.is_a?(ActivitiesViewModel)
  end

  def title
    object.nil? ? "All activities" : "#{object.class.name}: #{object.title}"
  end
  
  def render(template)
    return template.render partial: "activities/activity_list", locals: { activities: activities } if activities.length > 0
    template.render partial: "activities/empty"
  end
end
