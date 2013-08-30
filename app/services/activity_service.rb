class ActivityService
  attr_accessor :user, :action, :recorded_at
  
  def add_parameter key, *value
    raise ArgumentError.new("add_parameter must have 1 or 2 values") if !(1..2).include? value.length
    return parameters[key] = value[0] if value.length == 1
    
    parameters[key] = { old_value: value[0], new_value: value[1] }
  end
  
  def add_related object
    related_objects << {
      type: object.class.name,
      id: object.id,
      title: opinionated_title(object)
    }
  end
  
  def parameters
    @parameters ||= {}
  end
  
  def related_objects
    @related_objects ||= []
  end
  
  def log!
  end
  
  private
    POTENTIAL_TITLE_FIELDS = 
      [
        "title",
        "name"
      ]
  
    def opinionated_title object
      POTENTIAL_TITLE_FIELDS.each do |name|
        return object.send(name) if object.respond_to?(name)
      end
      return ""
    end
end