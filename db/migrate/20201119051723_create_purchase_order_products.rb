class CreatePurchaseOrderProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :purchase_order_products do |t|
      t.references :purchase_order,     null: false, foreign_key: true
      t.references :product,            null: false, foreign_key: true
      t.integer :quantity,              null: false, default: 1
      t.decimal :purchase_price,        null: false, precision: 8, scale: 2, default: 0
      t.decimal :total_purchase_price,  null: false, precision: 8, scale: 2, default: 0

      t.timestamps
    end
  end
end
