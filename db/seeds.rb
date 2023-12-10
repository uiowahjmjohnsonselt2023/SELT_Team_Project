# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#User test seeds
#User.create(name: "Garfield", email: "garf@test.com", password: "garfpassword", password_confirmation: "garfpassword", phone_number: "515-657-2381")
#Address.create(user_id: 5, street: "123 Cat St", city: "Cat City", zip: "12345", state: "CA", country: "USA")
#Address.create(user_id: 5, street: "456 Meow Ave", city: "Feline Town", zip: "67890", state: "NY", country: "USA")
#Address.create(user_id: 5, street: "789 Purr Ln", city: "Kitten Ville", zip: "10112", state: "TX", country: "USA")

require 'factory_bot_rails'

User.destroy_all
# Product.destroy_all
puts "#{User.count} users in the database"
puts "#{Product.count} products in the database"

puts "Creating users..."
# Create some categories
admin = FactoryBot.create(:user, name: "Admin", email: "admin@test.com", password: "password", password_confirmation: "password", admin: true)
admin = FactoryBot.create(:user, name: "Garfield", email: "garf@test.com", password: "garfpassword", password_confirmation: "garfpassword", admin: true)

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
