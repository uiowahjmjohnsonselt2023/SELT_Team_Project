class AddArchivedFlagToProduct < ActiveRecord::Migration
  def change
    add_column :products, :archived, :boolean, default: false
  end
end
