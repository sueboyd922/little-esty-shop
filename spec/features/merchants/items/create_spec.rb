require "rails_helper"

RSpec.describe "Merchant Item Create Page" do
  before(:each) do
    @merchant1 = Merchant.create!(name: "Klein, Rempel and Jones")
    @merchant2 = Merchant.create!(name: "Williamson Group")

    @item1 = @merchant1.items.create!(name: "Item Ea Voluptatum", description: "A thing that does things", unit_price: 7654)
    @item2 = @merchant1.items.create!(name: "Item Quo Magnam", description: "A thing that does nothing", unit_price: 10099)
    @item3 = @merchant1.items.create!(name: "Item Voluptatem Sint", description: "A thing that does everything", unit_price: 8790)
    @item4 = @merchant2.items.create!(name: "Item Rerum Est", description: "A thing that barks", unit_price: 3455)
    @item5 = @merchant2.items.create!(name: "Item Itaque Consequatur", description: "A thing that makes noise", unit_price: 7900)
  end

  it "has a form for new item, and redirects to merchant items index with new item listed" do
    visit "merchants/#{@merchant1.id}/items/new"

    within("#create_item") do
      fill_in "Name:", with: "Item Ea Voluptatum"
      fill_in "Description", with: "A thing that does things"
      fill_in "Unit Price:", with: 7654
      click_button "Submit"
    end
    expect(current_path).to eq("/merchants/#{@merchant1.id}/items")
save_and_open_page
   # within("div.item_#{@merchant1.items.last.id}") do  #no longer needed as enabled/disabled shows name links
      expect(page).to have_content("Item Ea Voluptatum")
    #end
  end
end
