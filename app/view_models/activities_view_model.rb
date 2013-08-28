class ActivitiesViewModel
  def activities
    @activities ||= Activity.everything
  end
end