# class Workspace < ApplicationRecord
#   has_many :categories, dependent: :destroy
#   has_many :tasks, through: :categories
#   has_many :workspace_memberships, dependent: :destroy
#   has_many :users, through: :workspace_memberships

#   validates :name, presence: true, uniqueness: true
#   validates :url, presence: true, uniqueness: true
#   validates :api_key, presence: true, uniqueness: true

# end


class Workspace < ApplicationRecord
    has_many :categories, dependent: :destroy
    has_many :tasks, through: :categories
    has_many :workspace_memberships, dependent: :destroy
    has_many :users, through: :workspace_memberships
  
    validates :name, presence: true, uniqueness: true
    validates :url, presence: true, uniqueness: true
    validates :api_key, presence: true, uniqueness: true
end
  