class Task < ActiveRecord::Base
  validates :title, presence: true
  validates_inclusion_of :completed, :in => [ true, false ]
  
  scope :todo, -> { where(completed: false).order(:position) }
  scope :completed, -> { where(completed: true).order("updated_at desc") }
end
