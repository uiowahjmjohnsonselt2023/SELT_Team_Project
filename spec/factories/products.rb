FactoryBot.define do
  factory :product do
    name { "Sample Product" }
    description { "A description for the product" }
    price { 20.0 }
    quantity { 10 }
    user_id {1}
    category_id {3}
    after(:create) do |product|
      tag1 = create(:tag, name: "Sample tag1")
      tag2 = create(:tag, name: "Sample tag2")
      product.tags << [tag1, tag2]
    end
  end
end
