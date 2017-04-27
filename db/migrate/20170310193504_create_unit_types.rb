class CreateUnitTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :unit_types do |t|

      t.timestamps
    end
  end
end
