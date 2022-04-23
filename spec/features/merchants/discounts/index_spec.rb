require 'rails_helper'

RSpec.describe 'merchant discounts index page', type: :feature do
  it 'has a link to view all of their discounts' do
    merchants = FactoryBot.create_list(:merchant, 2)

    discount1 = merchants[0].discounts.create!(quantity: 2, percent_discount: 25)
    discount2 = merchants[0].discounts.create!(quantity: 4, percent_discount: 30)
    discount3 = merchants[1].discounts.create!(quantity: 2, percent_discount: 50)

    visit "/merchants/#{merchants[0].id}/dashboard"
    click_on "My Discounts"
    expect(current_path).to eq("/merchants/#{merchants[0].id}/discounts")
    expect(page).to have_content("25% off 2 of the same item")
    expect(page).to have_content("30% off 4 of the same item")
    expect(page).not_to have_content("50% off 2 of the same item")

    within ".discount-#{discount1.id}" do
      click_on "Details"
      expect(current_path).to eq("/merchants/#{merchants[0].id}/discounts/#{discount1.id}")
    end

    visit "/merchants/#{merchants[1].id}/dashboard"
    click_on "My Discounts"
    within ".discount-#{discount3.id}" do
      click_on "Details"
      expect(current_path).to eq("/merchants/#{merchants[1].id}/discounts/#{discount3.id}")
    end
  end

  it 'can delete a discount' do
    merchants = FactoryBot.create_list(:merchant, 2)

    discount1 = merchants[0].discounts.create!(quantity: 2, percent_discount: 25)
    discount2 = merchants[0].discounts.create!(quantity: 4, percent_discount: 30)
    discount3 = merchants[1].discounts.create!(quantity: 2, percent_discount: 50)

    visit "/merchants/#{merchants[0].id}/dashboard"

    within ".discount-#{discount1.id}" do
      click_on "Delete"
    end
    expect(current_path).to eq("/merchants/#{merchant.id}/dashboard")
    expect(page).not_to have_content("25% off 2 of the same item")
    expect(merchant.discounts).not_to include(discount1)
  end

end
