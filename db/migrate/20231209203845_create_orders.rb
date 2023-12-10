class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.references :recent_purchase, foreign_key: true
      t.references :user, foreign_key: true
      t.string :card_number
      t.string :card_expiration
      t.string :card_cvv
      t.string :card_zip
      t.string :card_state
      t.string :card_city
      t.string :card_country
      t.string :first_name
      t.string :last_name

      t.timestamps null: false
    end
  end
end
