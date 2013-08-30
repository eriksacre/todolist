class ActivitiesViewModel
  def initialize(subject = null)
    @subject = subject
  end
  
  def activities
    @activities ||= subject.nil? ? Activity.everything : Activity.find_for(subject)
  end
  
  def subject
    @subject
  end
end