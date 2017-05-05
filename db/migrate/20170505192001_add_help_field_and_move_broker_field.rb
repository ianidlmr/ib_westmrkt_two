class AddHelpFieldAndMoveBrokerField < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :sale_person_name, :string
  end
end
