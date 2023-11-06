class UsersTable < ActiveRecord::Migration
  def change
    create_table :user do |t|
      t.string  :name
      t.string  :password_digest
      t.string  :email
      t.string  :phone_number
      t.boolean :verified_seller
      t.integer :rating
      t.string  :profile_picture
    end
    
    add_foreign_key :user, :review
    add_foreign_key :user, :payment_method
    add_foreign_key :user, :address
    add_foreign_key :user, :products
    add_foreign_key :user, :cart
  end

  def down
    drop_table :users
  end
end
