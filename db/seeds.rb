# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.create(name: "Admin", email: "admin@test.com", password: "password", password_confirmation: "password")

#User test seeds
#User.create(name: "Garfield", email: "garf@test.com", password: "garfpassword", password_confirmation: "garfpassword", phone_number: "515-657-2381")
#Address.create(user_id: 5, street: "123 Cat St", city: "Cat City", zip: "12345", state: "CA", country: "USA")
#Address.create(user_id: 5, street: "456 Meow Ave", city: "Feline Town", zip: "67890", state: "NY", country: "USA")
#Address.create(user_id: 5, street: "789 Purr Ln", city: "Kitten Ville", zip: "10112", state: "TX", country: "USA")
Product.create(name: "Lasagna", description: "A delicious lasagna", price: 10.0, quantity: 1, user_id: 5)
RecentPurchase.create(user_id: 2, product_id: 1, created_at: Time.now)

#Product test seeds
Product.create(name: "Apple", description: "A delicious apple", price: 0.99, quantity: 100, user_id: 1)
Product.create(name: "Banana", description: "A delicious banana", price: 1.99, quantity: 100, user_id: 1)
Product.create(name: "Orange", description: "A delicious orange", price: 2.99, quantity: 100, user_id: 1)
Product.create(name: "Pineapple", description: "A delicious pineapple", price: 3.99, quantity: 100, user_id: 1)
Product.create(name: "Grape", description: "A delicious grape", price: 4.99, quantity: 100, user_id: 1)
Product.create(name: "Strawberry", description: "A delicious strawberry", price: 5.99, quantity: 100, user_id: 1)
