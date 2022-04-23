require 'rails_helper'

RSpec.describe 'merchant discounts show page' do
  it 'has the info for a bulk discount' do
    merchants = FactoryBot.create_list(:merchant, 1)

    discount1 = merchants[0].discounts.create(quantity: 5, percent_discount: 10)
    discount2 = merchants[0].discounts.create(quantity: 4, percent_discount: 15)

    visit "/merchants/#{merchants[0].id}/discounts/#{discount1.id}"
    expect(page).to have_content("Discount: 10%")
    expect(page).to have_content("Item Count: 5")
    expect(page).not_to have_content("Discount: 15%")
    expect(page).not_to have_content("Item Count: 4")
  end
end
