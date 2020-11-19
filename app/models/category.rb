class Category < ApplicationRecord
  enum status: { active: 'active', inactive: 'inactive' }

  has_many :products
end
