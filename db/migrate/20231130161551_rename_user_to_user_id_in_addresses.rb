class RenameUserToUserIdInAddresses < ActiveRecord::Migration
  def change
    rename_column :addresses, :user, :user_id
  end
end
