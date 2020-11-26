class Product < ApplicationRecord
  enum status: { active: 'active', inactive: 'inactive' }

  belongs_to :category
  belongs_to :measure_unit

  has_one_attached :image

  has_many :purchase_order_products
  has_many :purchase_orders, through: :purchase_order_products

  validates :name, :code, :category_id, :measure_unit_id, :sale_price, :stock, :status, presence: true
end
