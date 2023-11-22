class AddIsPaymentAddressToAddresses < ActiveRecord::Migration
  def change
    add_column :addresses, :isPaymentAddress, :boolean
  end
end
