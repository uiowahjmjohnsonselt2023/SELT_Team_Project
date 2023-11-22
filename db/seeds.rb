# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'factory_bot_rails'

User.destroy_all
puts "#{User.count} users in the database"
puts "#{Product.count} products in the database"

puts "Creating users..."
admin = FactoryBot.create(:user, name: "Admin", email: "admin@test.com", password: "password", password_confirmation: "password")

5.times do
    product = FactoryBot.create(:product, name: Faker::Commerce.product_name, description: Faker::Lorem.paragraph, price: Faker::Commerce.price, quantity: Faker::Number.number(digits: 2), user_id: admin.id)
end