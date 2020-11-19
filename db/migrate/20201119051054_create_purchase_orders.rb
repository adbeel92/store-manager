class CreatePurchaseOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :purchase_orders do |t|
      t.references :provider,   null: false, foreign_key: true
      t.references :user,       null: false, foreign_key: true
      t.string :voucher_type
      t.string :voucher_series
      t.string :voucher_number
      t.decimal :tax,           precision: 8, scale: 2, default: 0
      t.decimal :total,         null: false, precision: 8, scale: 2, default: 0
      t.string :status,         null: false
      t.datetime :requested_at
      t.datetime :paid_at

      t.timestamps
    end
  end
end
