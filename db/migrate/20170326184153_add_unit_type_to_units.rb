class AddUnitTypeToUnits < ActiveRecord::Migration[5.0]
  def change
    add_reference :units, :unit_type, foreign_key: true
  end
end
