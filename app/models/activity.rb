class Activity < ActiveRecord::Base
  has_many :activity_relations
  belongs_to :user
  
  scope :everything, -> { ui_order.lazy }
  
  def self.since(timestamp, max_activities, subject=nil)
    return for_subject(subject).page_of_activities(timestamp, max_activities, "activity_relations.") if subject
    page_of_activities(timestamp, max_activities)
  end
  
  def self.find_for(subject)
    for_subject(subject).ui_order.lazy
  end
  
  private
    # Composites
    # TODO: Refactor qualifier
    def self.page_of_activities(timestamp, max_activities, qualifier="")
      after_timestamp(timestamp, qualifier).api_order.lazy.limit(max_activities)
    end
    
    # Conditions
    def self.after_timestamp(timestamp, qualifier="")
      where("#{qualifier}recorded_at >= :since", since: timestamp)
    end
    
    def self.for_subject(subject)
      joins(:activity_relations)
        .where("activity_relations.related_type = :klass and activity_relations.related_id = :id", klass: subject.class.name, id: subject.id)
    end
    
    # Sort orders
    def self.api_order
      order("recorded_at, id")
    end
    
    def self.ui_order
      order("recorded_at desc, id desc")
    end
    
    # Required lazy loading
    def self.lazy
      includes(:user)
    end
end
