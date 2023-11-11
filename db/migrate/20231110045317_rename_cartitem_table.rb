class RenameCartitemTable < ActiveRecord::Migration
  def change
    rename_table :cartitems, :cart_items
  end
end
