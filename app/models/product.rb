class Product < ApplicationRecord
  enum status: { active: 'active', inactive: 'inactive' }

  belongs_to :category

  has_one_attached :image

  has_many :purchase_order_products
  has_many :purchase_orders, through: :purchase_order_products
end
