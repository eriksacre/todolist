class Task < ActiveRecord::Base
  validates :title, presence: true
  validates_inclusion_of :completed, :in => [ true, false ]
  
  MAX_COMPLETED = 3
  
  scope :todo, -> { where(completed: false).order(:position) }
  scope :completed, -> { where(completed: true).order("completed_at desc") }
  scope :limited_completed, -> { completed.limit(MAX_COMPLETED) }
  
  def self.completed_count
    completed.count
  end
  
  def self.more?
    completed_count > MAX_COMPLETED
  end

  include ReadableUrl
end
