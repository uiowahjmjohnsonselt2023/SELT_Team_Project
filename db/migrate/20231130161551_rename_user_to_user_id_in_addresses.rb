class RenameUserToUserIdInAddresses < ActiveRecord::Migration
  def change
    add_column :addresses, :user, :integer
    rename_column :addresses, :user, :user_id
  end
end
