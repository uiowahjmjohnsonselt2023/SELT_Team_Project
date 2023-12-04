class AddVerifiedStatusToUsers < ActiveRecord::Migration
  def change
    add_column :users, :verified_seller, :boolean
  end
end
