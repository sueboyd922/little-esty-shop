FactoryBot.define do
  factory :invoice_item do
    association :item
    association :invoice
    status {[0, 1, 2].sample}
    quantity { Faker::Number.within(range: 1..10)}
    unit_price { Faker::Number.within(range: 1..100_000)}
    id { Faker::Number.unique.within(range: 1..1_000_000)}
  end
end