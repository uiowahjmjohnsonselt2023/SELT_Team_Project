FactoryBot.define do
    factory :user do
        name { Faker::Name.first_name }
        email { Faker::Internet.email }
        password { "password" }
        password_confirmation { "password" }
        admin { false }

        trait :admin do
            name { Faker::Name.first_name }
            email { Faker::Internet.email }
            password { "password" }
            password_confirmation { "password" }
            admin {true}
        end
    end

end
