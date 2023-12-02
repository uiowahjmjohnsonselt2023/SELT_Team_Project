class CreateRecentPurchases < ActiveRecord::Migration
  def change
    create_table :recent_purchases do |t|
      t.references :user, foreign_key: true
      t.references :product, foreign_key: true

      t.timestamps
    end
  end
end
