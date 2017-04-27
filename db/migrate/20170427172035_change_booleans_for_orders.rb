class ChangeBooleansForOrders < ActiveRecord::Migration[5.0]
  def change
    rename_column :orders, :agree_to_deal_sheet, :agree_to_deal_sheet_and_terms
    remove_column :orders, :agree_to_terms_and_conditions
  end
end
