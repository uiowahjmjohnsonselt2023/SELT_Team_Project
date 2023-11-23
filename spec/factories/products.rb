FactoryBot.define do
  factory :product do
    name { "Sample Product" }
    description { "A description for the product" }
    price { 20.0 }
    quantity { 10 }
    user_id {1}
    category_id {3}
  end
end
