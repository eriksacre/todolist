class DatabaseActivityService < SimpleDelegator
  def log!
    super
    Activity.new.tap do |a|
      a.user_id = self.user
      a.action = self.action
      a.recorded_at = self.recorded_at
      a.info = { parameters: parameters, related_objects: related_objects }.to_json
      
      a.save!
      save_related_objects a
    end
  end
  
  private
    def save_related_objects activity
      related_objects.each do |object|
        activity.activity_relations.create do |relation|
          relation.action = activity.action
          relation.recorded_at = activity.recorded_at
          relation.related_id = object[:id]
          relation.related_type = object[:type]
        end
      end
    end
end