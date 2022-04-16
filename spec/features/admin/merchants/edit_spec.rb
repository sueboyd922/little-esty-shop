require "rails_helper"

RSpec.describe "the admin merchants edit page" do
  it "show page has a link leads to editing an existing merchant" do
    merchant = FactoryBot.create_list(:merchant,1)[0]
    visit "/admin/merchants/#{merchant.id}" 

    click_link 'Update Merchant'
    expect(current_path).to eq("/admin/merchants/#{merchant.id}/edit")

    fill_in 'name', with: 'Something new'
    click_button 'Submit'
    
    expect(page).to have_content("Something new")
  end
end
