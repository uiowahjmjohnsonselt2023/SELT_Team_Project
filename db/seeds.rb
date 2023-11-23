# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.create(name: "Admin", email: "admin@test.com", password: "password", password_confirmation: "password")
User.create(name: "Garfield", email: "garf@test.com", password: "garfpassword", password_confirmation: "garfpassword",
            address_id: 4495, phone_number: "515-657-2381")
Address.create(id: 4495, street: "888 ToonTown avenue")
Product.create(name: "Apple", description: "A delicious apple", price: 0.99, quantity: 100, user_id: 1)
Product.create(name: "Banana", description: "A delicious banana", price: 1.99, quantity: 100, user_id: 1)
Product.create(name: "Orange", description: "A delicious orange", price: 2.99, quantity: 100, user_id: 1)
Product.create(name: "Pineapple", description: "A delicious pineapple", price: 3.99, quantity: 100, user_id: 1)
Product.create(name: "Grape", description: "A delicious grape", price: 4.99, quantity: 100, user_id: 1)
Product.create(name: "Strawberry", description: "A delicious strawberry", price: 5.99, quantity: 100, user_id: 1)
