FactoryBot.define do
  factory :item do
    name { Faker::Book.name }
    description { Faker::Book.name }
    unit_price { Faker::Number.number(digits: 4)}
    association :merchant, factory: :merchant
  end
end
