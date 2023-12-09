class AddLoggedInToUsers < ActiveRecord::Migration
  def change
    add_column :users, :loggedIn, :boolean
  end
end
