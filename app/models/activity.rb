class Activity < ActiveRecord::Base
  has_many :activity_relations
  belongs_to :user
  
  scope :everything, -> { order("recorded_at desc").includes(:user) }
end
