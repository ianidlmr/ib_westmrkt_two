class AddImageFieldsToUnitAndUnitTypes < ActiveRecord::Migration[5.0]
  def change
    add_column :units, :key_map_top_image, :string
    add_column :units, :key_map_side_image, :string
    add_column :units, :view_from_window_image, :string
    add_column :unit_types, :floor_plan_image, :string
  end
end
