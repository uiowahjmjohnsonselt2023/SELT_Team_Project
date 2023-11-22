class AddUserIdToAddresses < ActiveRecord::Migration
  def change
    add_column :addresses, :userId, :reference
  end
end
