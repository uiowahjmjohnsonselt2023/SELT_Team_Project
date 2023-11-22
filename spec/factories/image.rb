
FactoryBot.define do
    factory :image do
        association :user
        association :product
        image { Dragonfly.app.fetch_url(Faker::LoremFlickr.image(size: "150x150"), search_term: ['product']) }
    end
end