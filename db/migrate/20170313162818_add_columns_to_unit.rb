class AddColumnsToUnit < ActiveRecord::Migration[5.0]
  def change
    add_column :units, :unit_number, :integer
    add_column :units, :floor_number, :integer
    add_column :units, :orientation, :string
    add_column :units, :price, :integer
    add_column :units, :savings, :integer
    add_column :units, :currency, :string
  end
end
