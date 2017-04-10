class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
      t.string :state
      t.references :user, index: true, foreign_key: true
      t.string :stripe_charge_id
      t.timestamps null: false

      t.timestamps
    end
  end
end
