class AddUserIdToAddresses < ActiveRecord::Migration
  def change
    add_reference :addresses, :user_id, index: true, foreign_key: true
  end
end
