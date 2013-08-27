class InteractorBase
  def self.dependencies *args
    args.each do |dependency|
      define_method("#{dependency}=".to_sym) do |value|
        instance_variable_set("@#{dependency}", value)
      end
      
      define_method("#{dependency}".to_sym) do
        value = instance_variable_get("@#{dependency}")
        return dependency.to_s.camelize.constantize if !value
        value
      end
    end
  end
  
  def initialize(current_user)
    @current_user = current_user
  end
  
  def run
    perform.tap do |object|
      log_activity object
    end
  end
    
  def log_activity object
    new_activity_service.tap do |activity|
      activity.user = @current_user.id
      activity.action = self.class.name
      activity.recorded_at = object.updated_at
      activity.add_related object
      log_specifics activity, object
      activity.log!
    end
  end
  
  def perform
  end
  
  def log_specifics activity, object
  end
  
  attr_writer :new_activity_service
  def new_activity_service
    @new_activity_service ||= DatabaseActivityService.new(ActivityService.new)
  end
end
