class AddColumnsToUnitTypes < ActiveRecord::Migration[5.0]
  def change
    add_column :unit_types, :name, :string
    add_column :unit_types, :description, :text
    add_column :unit_types, :front_page_description, :text
    add_column :unit_types, :quantity_remaining, :integer
    add_column :unit_types, :number_of_bedrooms, :integer
    add_column :unit_types, :number_of_bathrooms, :integer
    add_column :unit_types, :balcony_sqft, :integer
    add_column :unit_types, :interior_sqft, :integer
    add_column :unit_types, :den, :boolean
    add_column :unit_types, :balcony, :boolean
  end
end
