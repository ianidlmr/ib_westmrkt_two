class AddAdminUser < ActiveRecord::Migration[5.0]
  def change
    Admin.create!(email: 'admin@railway-market.com', password: 'password', password_confirmation: 'password')
  end
end
