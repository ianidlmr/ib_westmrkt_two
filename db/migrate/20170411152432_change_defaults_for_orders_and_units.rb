class ChangeDefaultsForOrdersAndUnits < ActiveRecord::Migration[5.0]
  def change
    change_column :orders, :payment_state, :string, default: 'in_progress'
    change_column :units, :state, :string, default: 'available'
  end
end
