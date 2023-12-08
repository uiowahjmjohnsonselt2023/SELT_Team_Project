FactoryBot.define do
  factory :product do
    name { "Sample Product" }
    description { "A description for the product" }
    price { 20.0 }
    quantity { 10 }
    user_id {1}
    discount {0}
    category_id { FactoryBot.create(:category).id }
    after(:create) do |product|
      tag1 = Tag.find_or_create_by(name: "Sample tag1")
      tag2 = Tag.find_or_create_by(name: "Sample tag2")
      product.tags << [tag1, tag2]
    end

  end
end
