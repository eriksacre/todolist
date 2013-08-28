class Activity < ActiveRecord::Base
  has_many :activity_relations
  belongs_to :user
  
  scope :everything, -> { order("recorded_at desc, id desc").includes(:user) }
  
  def self.since(timestamp, max_activities)
    where("recorded_at >= ?", timestamp).order("recorded_at, id").includes(:user).limit(max_activities)
  end
end
