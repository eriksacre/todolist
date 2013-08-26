class ActivityService
  attr_accessor :user, :action, :recorded_at
  
  def add_parameter key, *value
    raise ArgumentError.new("add_parameter must have 1 or 2 values") if !(1..2).include? value.length
    return parameters[key] = value[0] if value.length == 1
    
    parameters[key] = {}
    parameters[key][:old_value] = value[0]
    parameters[key][:new_value] = value[1]
  end
  
  def add_related object
    object_description = {}
    object_description[:type] = object.class.name.underscore
    object_description[:id] = object.id
    object_description[:title] = opinionated_title(object)
    related_objects << object_description
  end
  
  def parameters
    @parameters ||= {}
  end
  
  def related_objects
    @related_objects ||= []
  end
  
  def save!
    Activity.new.tap do |a|
      a.user_id = self.user
      a.action = self.action
      a.recorded_at = self.recorded_at
      a.info = { parameters: parameters, related_objects: related_objects }.to_json
      
      a.save!
    end
  end
  
  private
    POTENTIAL_TITLE_FIELDS = 
      [
        "title",
        "name"
      ]
  
    def opinionated_title object
      POTENTIAL_TITLE_FIELDS.each do |name|
        return object.send(name) if object.columns.has_key?(name) && object.columns[name].type == :string
      end
      return ""
    end
end