class AddUserToAddress < ActiveRecord::Migration[5.0]
  def change
    add_reference :addresses, :user, index: true, foreign_key: true
  end
end
