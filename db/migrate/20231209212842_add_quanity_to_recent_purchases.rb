class AddQuanityToRecentPurchases < ActiveRecord::Migration
  def change
    add_column :recent_purchases, :quantity, :integer
    add_reference :recent_purchases, :order, foreign_key: true
  end
end
