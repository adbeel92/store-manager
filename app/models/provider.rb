class Provider < ApplicationRecord
  enum status: { new_one: 'new_one', contacted: 'contacted', active: 'active', inactive: 'inactive' }

  has_many :purchase_orders

  validates :name, :status, presence: true
end
