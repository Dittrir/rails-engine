FactoryBot.define do
  factory :item do
    name { Faker::Name.name }
    description { Faker::Lorem.paragraph }
    unit_price { Faker::Number.number(digits: 4)}
    association :merchant, factory: :merchant
  end
end
