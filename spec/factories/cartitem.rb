# spec/factories/cart_items.rb
FactoryBot.define do
    factory :cart_item do
        quantity { 1 }
        association :product
        association :cart
    end
end