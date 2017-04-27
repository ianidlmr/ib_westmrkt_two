class AddUserToUnit < ActiveRecord::Migration[5.0]
  def change
    add_reference :units, :owner, index: true
  end
end
