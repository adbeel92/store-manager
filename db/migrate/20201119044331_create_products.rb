class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string :code
      t.string :name,             null: false
      t.references :category,     null: false, foreign_key: true
      t.references :measure_unit, null: false, foreign_key: true
      t.decimal :sale_price,      null: false, precision: 8, scale: 2, default: 0
      t.integer :stock,           null: false, default: 0
      t.integer :custom_stock,    null: true
      t.text :description
      t.string :status,           null: false

      t.timestamps
      t.index [ :code ], unique: true
    end
  end
end
