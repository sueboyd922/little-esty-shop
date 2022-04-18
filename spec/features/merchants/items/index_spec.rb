require "rails_helper"

RSpec.describe "merchants items index page", type: :feature do
  before(:each) do
    @merchant1 = Merchant.create!(name: "Klein, Rempel and Jones")
    @merchant2 = Merchant.create!(name: "Williamson Group")

    @item1 = @merchant1.items.create!(name: "Item Ea Voluptatum", description: "A thing that does things", unit_price: 7654)
    @item2 = @merchant1.items.create!(name: "Item Quo Magnam", description: "A thing that does nothing", unit_price: 10099)
    @item3 = @merchant1.items.create!(name: "Item Voluptatem Sint", description: "A thing that does everything", unit_price: 8790, status: "disabled")
    @item4 = @merchant2.items.create!(name: "Item Rerum Est", description: "A thing that barks", unit_price: 3455)
    @item5 = @merchant2.items.create!(name: "Item Itaque Consequatur", description: "A thing that makes noise", unit_price: 7900)
  end

  it "has all the names of a merchants items" do
    visit "merchants/#{@merchant1.id}/items"
    expect(page).to have_content(@item1.name)
    expect(page).to have_content(@item2.name)
    expect(page).to have_content(@item3.name)
    expect(page).not_to have_content(@item4.name)
    expect(page).not_to have_content(@item5.name)
  end

  it "has a link to create a new item" do
    visit "/merchants/#{@merchant1.id}/items"

    click_link("Create New Item")

    expect(current_path).to eq("/merchants/#{@merchant1.id}/items/new")
  end

  it "has the ability to enable or disable an item" do
    visit "/merchants/#{@merchant1.id}/items"

    expect(@item1.status).to eq("enabled")

    within ".item-#{@item1.id}" do
      click_on "Disable"
    end
    expect(current_path).to eq("/merchants/#{@merchant1.id}/items")
    expect(Item.find(@item1.id).status).to eq("disabled")
    within ".item-#{@item1.id}" do
      expect(page).to have_button("Enable")
      expect(page).not_to have_button("Disable")
    end

    visit "/merchants/#{@merchant1.id}/items"

    expect(@item3.status).to eq("disabled")
    within ".item-#{@item3.id}" do
      click_on "Enable"
    end
    expect(current_path).to eq("/merchants/#{@merchant1.id}/items")
    expect(Item.find(@item3.id).status).to eq("enabled")
    within ".item-#{@item3.id}" do
      expect(page).to have_button("Disable")
      expect(page).not_to have_button("Enable")
    end
  end

  it "groups items by disabled or enabled items" do
    visit "/merchants/#{@merchant1.id}/items"

    expect(page).to have_content("Enabled Items")
    expect(page).to have_content("Disabled Items")

    within ".enabled" do
      expect(page).to have_content(@item1.name)
      expect(page).to have_content(@item2.name)
    end

    within ".disabled" do
      expect(page).to have_content(@item3.name)
    end
  end

  it "section with top 5 popular_items" do
    merchant_1 = Merchant.create!(name: "Stuff and Things ")
    item_1 = FactoryBot.create_list(:item, 1, merchant_id: merchant_1.id)[0]
    item_2 = FactoryBot.create_list(:item, 2, merchant_id: merchant_1.id)[1]
    item_3 = FactoryBot.create_list(:item, 3, merchant_id: merchant_1.id)[2]
    item_4 = FactoryBot.create_list(:item, 4, merchant_id: merchant_1.id)[3]
    item_5 = FactoryBot.create_list(:item, 5, merchant_id: merchant_1.id)[4]
    item_6 = FactoryBot.create_list(:item, 6, merchant_id: merchant_1.id)[5]
    item_7 = FactoryBot.create_list(:item, 7, merchant_id: merchant_1.id)[6]

    FactoryBot.create_list(:customer, 7)
    cust1 = Customer.all[0]
    cust2 = Customer.all[1]
    cust3 = Customer.all[2]
    cust4 = Customer.all[3]
    cust5 = Customer.all[4]
    cust6 = Customer.all[5]
    cust7 = Customer.all[6]

    invoice1 = FactoryBot.create_list(:invoice, 1, customer_id: cust1.id, status: 2)[0]
    invoice2 = FactoryBot.create_list(:invoice, 2, customer_id: cust2.id, status: 2)[1]
    invoice3 = FactoryBot.create_list(:invoice, 3, customer_id: cust3.id, status: 2)[2]
    invoice4 = FactoryBot.create_list(:invoice, 4, customer_id: cust4.id, status: 2)[3]
    invoice5 = FactoryBot.create_list(:invoice, 5, customer_id: cust5.id, status: 0)[4]
    invoice6 = FactoryBot.create_list(:invoice, 6, customer_id: cust6.id, status: 2)[5]
    invoice7 = FactoryBot.create_list(:invoice, 7, customer_id: cust7.id, status: 2)[6]

    FactoryBot.create_list(:invoice_item, 1, item_id: item_1.id, invoice_id: invoice1.id)
    FactoryBot.create_list(:invoice_item, 2, item_id: item_2.id, invoice_id: invoice2.id)
    FactoryBot.create_list(:invoice_item, 3, item_id: item_3.id, invoice_id: invoice3.id)
    FactoryBot.create_list(:invoice_item, 4, item_id: item_4.id, invoice_id: invoice4.id)
    FactoryBot.create_list(:invoice_item, 5, item_id: item_5.id, invoice_id: invoice5.id)
    FactoryBot.create_list(:invoice_item, 6, item_id: item_6.id, invoice_id: invoice6.id)
    FactoryBot.create_list(:invoice_item, 7, item_id: item_7.id, invoice_id: invoice7.id)

    FactoryBot.create_list(:transaction, 1, invoice_id: invoice1.id, result: 1)
    FactoryBot.create_list(:transaction, 2, invoice_id: invoice2.id, result: 0)
    FactoryBot.create_list(:transaction, 3, invoice_id: invoice3.id, result: 0)
    FactoryBot.create_list(:transaction, 4, invoice_id: invoice4.id, result: 0)
    FactoryBot.create_list(:transaction, 5, invoice_id: invoice5.id, result: 1)
    FactoryBot.create_list(:transaction, 6, invoice_id: invoice6.id, result: 0)
    FactoryBot.create_list(:transaction, 7, invoice_id: invoice7.id, result: 0)
    visit "/merchants/#{merchant_1.id}/items"
    expect(page).to have_content("Top 5 Items by Revenue")

    within ".top_items" do
      expect(page).to have_link(item_7.name)
      expect(page).to have_link(item_6.name)
      expect(page).to have_link(item_4.name)
      expect(page).to have_link(item_3.name)
      expect(page).to have_link(item_2.name)

      expect(item_7.name).to appear_before(item_6.name)
      expect(item_6.name).to appear_before(item_4.name)
      expect(item_4.name).to appear_before(item_2.name)

      # expect(page).to have_content(@item.totalrevenue)
      # expect(page).to have_content("9899016")
      # expect(page).to have_content("3737512")
      # expect(page).to have_content("1897324")
      # expect(page).to have_content("1244265")
    end
    within ".top_items" do
      click_link(item_2.name)
    end
    expect(current_path).to eq("/merchants/#{merchant_1.id}/items/#{item_2.id}")
  end
end
