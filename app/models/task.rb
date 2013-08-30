class Task < ActiveRecord::Base
  validates :title, presence: true
  validates_inclusion_of :completed, :in => [ true, false ]
  
  scope :todo, -> { where(completed: false).order(:position) }
  scope :completed, -> { where(completed: true).order("completed_at desc") }
  
  def self.limited_completed(limit)
    completed.limit(limit)
  end
  
  def self.completed_count
    completed.count
  end
  
  include ReadableUrl
end
