class ActivitiesViewModel
  def initialize(object = null)
    @object = object
  end
  
  def activities
    @activities ||= @object.nil? ? Activity.everything : Activity.find_for(@object)
  end
  
  def object
    @object
  end
end