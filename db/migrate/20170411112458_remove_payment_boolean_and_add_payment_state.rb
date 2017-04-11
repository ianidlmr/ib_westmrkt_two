class RemovePaymentBooleanAndAddPaymentState < ActiveRecord::Migration[5.0]
  def change
    remove_column :orders, :payment_confirmed
    add_column :orders, :payment_state, :string
  end
end
