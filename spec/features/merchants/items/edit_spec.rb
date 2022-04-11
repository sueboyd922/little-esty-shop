require "rails_helper"

RSpec.describe "Merchant Items Edit Page" do
  before(:each) do
    @merchant1 = Merchant.create!(name: "Klein, Rempel and Jones")
    @merchant2 = Merchant.create!(name: "Williamson Group")

    @item1 = @merchant1.items.create!(name: "Item Ea Voluptatum", description: "A thing that does things", unit_price: 7654)
    @item2 = @merchant1.items.create!(name: "Item Quo Magnam", description: "A thing that does nothing", unit_price: 10099)
    @item3 = @merchant1.items.create!(name: "Item Voluptatem Sint", description: "A thing that does everything", unit_price: 8790)
    @item4 = @merchant2.items.create!(name: "Item Rerum Est", description: "A thing that barks", unit_price: 3455)
    @item5 = @merchant2.items.create!(name: "Item Itaque Consequatur", description: "A thing that makes noise", unit_price: 7900)
  end
  it "I see a form filled in with existing info" do
    visit "/merchants/#{@merchant1.id}/items/#{@item2.id}/edit"

    expect(page).to have_field(:name, with: @item2.name)
    expect(page).to have_field(:description, with: @item2.description)
    expect(page).to have_field(:unit_price, with: @item2.unit_price)
  end

  it "when the form is filled out and submitted, the user is redirected to the show page and the updated info is shown" do
    visit "/merchants/#{@merchant1.id}/items/#{@item2.id}//edit"

    within("#update_item") do
      fill_in "unit_price", with: 12345
      click_on "Update Item"
    end
    expect(current_path).to eq("/merchants/#{@merchant1.id}/items/#{@item2.id}")
    @item2.reload
    expect(@item2.unit_price).to eq(12345)
    expect(page).to have_content("Items Successfully Updated")
  end
end
