FactoryBot.define do
  factory :merchant do
    name { Faker::Company.name }
    status {[0, 1].sample}
    id { Faker::Number.unique.within(range: 1..100_000) }
  end
end