FactoryBot.define do
  factory :product do
    name { "Sample Product" }
    description { "A description for the product" }
    price { 20.0 }
    quantity { 10 }
    user_id {1}
  end
  factory :user do 
    name {"james"}
    email {"james@gmail.com"}
    password {"123456"}
    password_confirmation {"123456"}
  end

end
