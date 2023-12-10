class CreateUserImages < ActiveRecord::Migration
  def change
    create_table :user_images do |t|
      t.references :image, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
