# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'factory_bot_rails'

admin = FactoryBot.create(:user, name: "Admin", email: "admin@test.com", password: "password", password_confirmation: "password")
admin.cart = FactoryBot.create(:cart)
admin.save

10.times do
    FactoryBot.create(:product, name: Faker::Commerce.product_name, description: Faker::Lorem.paragraph, price: Faker::Commerce.price, quantity: Faker::Number.number(digits: 2), user_id: 1)
end