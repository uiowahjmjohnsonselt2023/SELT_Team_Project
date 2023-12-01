class AddZipToAddresses < ActiveRecord::Migration
  def change
    add_column :addresses, :zip, :string
  end
end
