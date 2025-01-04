# class Task < ApplicationRecord

#   belongs_to :workspace, optional: true
#   belongs_to :assignee, class_name: 'User', optional: true
#   belongs_to :category, optional: true

#   # Validations
#   validates :title, presence: true, length: { maximum: 255 }
#   validates :due_date, presence: true
#   validates :priority, inclusion: { in: [1, 2, 3], message: 'must be 1 (High), 2 (Medium), or 3 (Low)' }
#   validates :completion_status, inclusion: { in: [true, false] }

#     # # Scopes (Optional, for easier querying)
#   # scope :completed, -> { where(completion_status: true) }
#   # scope :pending, -> { where(completion_status: false) }
# end




class Task < ApplicationRecord
  belongs_to :category
  belongs_to :assignee, class_name: 'User', optional: true

  validates :title, presence: true, length: { maximum: 255 }
  validates :due_date, presence: true
  validates :priority, inclusion: { in: [1, 2, 3], message: 'must be 1 (High), 2 (Medium), or 3 (Low)' }
  validates :completion_status, inclusion: { in: [true, false] }
end
