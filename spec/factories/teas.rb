FactoryBot.define do
  factory :tea do
    title { Faker::Tea.variety }
    description { Faker::Tea.type }
    temperature { Faker::Number.decimal(l_digits: 2) }
    brew_time { Faker::Time }
  end
end