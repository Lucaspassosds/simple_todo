class Task < ApplicationRecord
  validates :title, presence: true
  
  default_scope { order(created_at: :desc) }
  
  scope :complete, -> { where(completed: true) }
  scope :pending, -> { where(completed: false) }
end
