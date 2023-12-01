class AddReviewsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :reviews, :integer
  end
end
