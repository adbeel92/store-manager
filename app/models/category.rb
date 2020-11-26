class Category < ApplicationRecord
  enum status: { active: 'active', inactive: 'inactive' }

  has_many :products

  validates :name, :status, presence: true
end
