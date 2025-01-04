# class Category < ApplicationRecord
#   has_many :tasks, dependent: :nullify
#   belongs_to  :workspace
#   validates :name, presence: true, uniqueness: true
# end


class Category < ApplicationRecord
  has_many :tasks, dependent: :nullify
  belongs_to :workspace

  validates :name, presence: true, uniqueness: { scope: :workspace_id }
end
