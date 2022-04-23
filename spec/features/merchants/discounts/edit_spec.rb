require 'rails_helper'

RSpec.describe "merchant discounts edit page", type: :feature do
  it 'allows a merchant to edit a discount' do
    merchants = FactoryBot.create_list(:merchant, 1)

    discount1 = merchants[0].discounts.create(quantity: 5, percent_discount: 10)
    discount2 = merchants[0].discounts.create(quantity: 4, percent_discount: 15)

    visit "/merchants/#{merchants[0].id}/discounts/#{discount1.id}"
    click_on "Edit"
    expect(current_path).to eq("/merchants/#{merchants[0].id}/discounts/#{discount1.id}/edit")
    
    expect(page).to have_field(:quantity, with: 5)
    expect(page).to have_field(:percent_discount, with: 10)

    fill_in(:quantity, with: 15)
    fill_in(:percent_discount, with: 20)

    click_on("Submit")

    expect(current_path).to eq("/merchants/#{merchants[0].id}/discounts/#{discount1.id}")

    expect(page).to have_content("Discount: 20%")
    expect(page).to have_content("Item Count: 15")
    expect(page).not_to have_content("Discount: 10%")
    expect(page).not_to have_content("Item Count: 5")

    expect(Discount.find(discount1.id).quantity).to eq(15)
    expect(Discount.find(discount1.id).percent_discount).to eq(20)
  end
end
