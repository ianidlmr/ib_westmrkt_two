# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Admin.create!(email: 'ecommerce@idlmr.com', password: 'TskApAck8c2qs8UU', password_confirmation: 'TskApAck8c2qs8UU')
Setting.pre_sale_start_date = 1
Setting.pre_sale_end_date = 2

