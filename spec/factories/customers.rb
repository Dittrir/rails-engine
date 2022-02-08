FactoryBot.define do
  factory :customer do
    first_name { Faker::Book.name }
    last_name { Faker::Book.name }
  end
end
