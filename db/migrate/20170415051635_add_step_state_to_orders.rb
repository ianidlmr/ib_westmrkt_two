class AddStepStateToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :current_step, :string, default: 'update-personal-info'
  end
end
