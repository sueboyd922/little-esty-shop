require 'rails_helper'

RSpec.describe 'The admin merchant index' do

  before :each do
    @merchant1 = FactoryBot.create_list(:merchant, 1)[0]
    @merchant2 = FactoryBot.create_list(:merchant, 1)[0]
    @merchant3 = FactoryBot.create_list(:merchant, 1)[0]
  end

  it "has a button to enable or disable a merchant" do
    visit "admin/merchants"
    expect(page).to have_content(@merchant2.name)
    expect(page).to have_content(@merchant3.name)
    expect(page).to have_content(@merchant1.name)

    within("#enabled_merchant-#{@merchant1.id}") do
      expect(@merchant1.status).to eq "enabled"
      expect(page).to have_content('enabled')
      click_button "Disable", match: :first
      expect(current_path).to eq "/admin/merchants"
    end

    within("#disabled_merchant-#{@merchant1.id}") do
      expect(page).to have_content(@merchant1.name)
      updated_merchant = Merchant.find(@merchant1.id)
      expect(page).to have_content(updated_merchant.status)
      expect(page).to have_button('Enable')
    end

  end

end
