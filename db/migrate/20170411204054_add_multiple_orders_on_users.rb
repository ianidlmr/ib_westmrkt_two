class AddMultipleOrdersOnUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :allow_multiple_orders, :boolean, default: false
    remove_column :users, :social_insurance_number
  end
end
