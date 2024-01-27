FactoryBot.define do
  factory :tea do
    title { Faker::Tea.variety }
    description { Faker::Tea.type }
    temperature { Faker::Number.decimal(l_digits: 2) }
    brew_time { "#{Faker::Number.between(from: 1, to: 10)} min #{Faker::Number.between(from: 0, to: 59)} sec" }
  end
end