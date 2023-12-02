class RemoveColumnNameFromAddresses < ActiveRecord::Migration
  def change
    remove_column :addresses, :user_id_id, :integer
  end
end
