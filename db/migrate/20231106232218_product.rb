class Product < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.string :descripton
      t.decimal :price
      t.integer :quantity
      t.timestamps null: false
    end
  end
end
