require 'rails_helper'

RSpec.describe "merchants discounts new page", type: :feature do
  it 'allows the merchant to create a new discount' do
    merchant = FactoryBot.create_list(:merchant, 1).first

    visit "merchants/#{merchant.id}/discounts"
    click_on "Add New Discount"

    expect(current_path).to eq("/merchants/#{merchant.id}/discounts/new")

    fill_in :quantity, with: 5
    fill_in :percent_discount, with: 22
    click_on "Add"

    expect(current_path).to eq("/merchants/#{merchant.id}/discounts")
    expect(page).to have_content("22% off 5 of the same item")
  end

  xit 'does not allow invalid inputs' do
    merchant = FactoryBot.create_list(:merchant, 1).first
    visit "/merchants/#{merchant.id}/discounts/new"

    fill_in :quantity, with: 10
    fill_in :percent_discount, with: 102
    click_on "Add"


    expect(current_path).to eq("/merchants/#{merchant.id}/discounts")
    expect(page).to have_content("Please enter a number 1-99")
  end
end
