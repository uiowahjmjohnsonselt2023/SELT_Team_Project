class AddDiscountToProducts < ActiveRecord::Migration
  def change
    add_column :products, :discount, :integer, precision: 5, scale: 2, default: 0.0
  end
end
