class CreateProviders < ActiveRecord::Migration[6.0]
  def change
    create_table :providers do |t|
      t.string :name,     null: false
      t.string :status,   null: false
      t.string :ruc
      t.string :address
      t.string :phone_1
      t.string :phone_2
      t.text :description

      t.timestamps
    end
  end
end
