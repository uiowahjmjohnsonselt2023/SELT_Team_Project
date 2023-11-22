
FactoryBot.define do
    factory :image do
        title { Faker::Lorem.word }
        url { Faker::LoremFlickr.unique.image }
        association :user
        association :product
    end
end
