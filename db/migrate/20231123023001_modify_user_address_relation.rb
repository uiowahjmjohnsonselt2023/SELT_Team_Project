class ModifyUserAddressRelation < ActiveRecord::Migration
  def change
    remove_column :users, :address_id
    add_reference :addresses, :user, foreign_key: true
  end
end
