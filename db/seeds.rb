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

# Create some categories
categories = Category.create([
                               { name: 'Food' },
                               { name: 'Electronics' },
                               { name: 'Books' },
                               { name: 'Toys & Games' },
                               { name: 'Sporting Goods' },
                               { name: 'Clothing & Accessories'},
                               { name: 'Everything else'}
                             ])
                             
5.times do
    category = categories.sample # Randomly select a category
    product = FactoryBot.create(:product, name: Faker::Commerce.product_name, 
                                            description: Faker::Lorem.paragraph, 
                                            price: Faker::Commerce.price, 
                                            quantity: Faker::Number.number(digits: 2), 
                                            category_id: category.id, user_id: admin.id)
end
