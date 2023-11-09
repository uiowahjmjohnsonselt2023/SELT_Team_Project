class CreateCartProducts < ActiveRecord::Migration
  def change
    create_table :cart_products do |t|
      t.belongs_to :product, index: true, foreign_key: true
      t.belongs_to :cart, index: true, foreign_key: true
      t.integer :quantity

      t.timestamps null: false
    end
  end
end
