class PurchaseOrder < ApplicationRecord
  enum status: { new_one: 'new_one', requested: 'requested', approved: 'approved', rejected: 'rejected', paid: 'paid' }

  belongs_to :provider
  belongs_to :user

  has_one_attached :voucher

  has_many :purchase_order_products
  has_many :products, through: :purchase_order_products
end
