class PurchaseOrderProduct < ApplicationRecord
  belongs_to :purchase_order
  belongs_to :product

  validates :product_id, :quantity, :purchase_price, :total_purchase_price, presence: true

  def status
    purchase_order.status
  end
end
