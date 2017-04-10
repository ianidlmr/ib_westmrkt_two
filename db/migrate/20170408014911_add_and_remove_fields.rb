class AddAndRemoveFields < ActiveRecord::Migration[5.0]
  def change
    remove_column :unit_types, :quantity_remaining
    add_reference :orders, :unit, index: true, foreign_key: true
    add_column :units, :state, :string
    add_column :orders, :payment_confirmed, :boolean, default: false
    add_column :orders, :promo_code, :string
    add_column :orders, :agree_to_deal_sheet, :boolean, default: false
    add_column :orders, :agree_to_terms_and_conditions, :boolean, default: false
    add_column :orders, :broker, :boolean, default: false
    add_column :users, :phone_number, :string
    add_column :users, :occupation, :string
    add_column :users, :social_insurance_number, :string
  end
end
