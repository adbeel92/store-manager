class Role < ApplicationRecord
  enum status: { active: 'active', inactive: 'inactive' }

  has_many :users
end
