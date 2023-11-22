class AddImageNameToImages < ActiveRecord::Migration
  def change
    add_column :images, :image_name, :string
  end
end
