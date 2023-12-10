class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :address
      t.string :street
      t.string :zip
      t.string :city
      t.string :country
      t.string :state
      
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
