class RenameProductColumnDescriptonToDescription < ActiveRecord::Migration
  def change
    rename_column :products, :descripton, :description
  end
end
