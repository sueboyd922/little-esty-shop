require 'rails_helper'

RSpec.describe 'The admin merchant index' do

  before :each do
    @merchant1 = FactoryBot.create_list(:merchant, 1)[0]
    @merchant2 = FactoryBot.create_list(:merchant, 1)[0]
    @merchant3 = FactoryBot.create_list(:merchant, 1)[0]
  end

  it "has a button to enable or disable a merchant" do
    visit "admin/merchants"

    expect(page).to have_content(@merchant1.name)
    expect(page).to have_content(@merchant2.name)
    expect(page).to have_content(@merchant3.name)
    expect(page).to have_button('Enabled')

    click_button "Enable"

    expect(current_path).to eq "admin/merchants"
  end

  it "updates the merchant status when disabled or enabled" do

  end

end
