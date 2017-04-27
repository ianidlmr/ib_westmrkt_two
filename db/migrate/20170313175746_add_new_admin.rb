class AddNewAdmin < ActiveRecord::Migration[5.0]
  def change
    Admin.destroy_all
    Admin.create!(email: 'ecommerce@idlmr.com', password: 'TskApAck8c2qs8UU', password_confirmation: 'TskApAck8c2qs8UU')
  end
end
