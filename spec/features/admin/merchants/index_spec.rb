require "rails_helper"

RSpec.describe "the admin merchants indexpage" do
  it 'lists all merchants name in the system' do
    FactoryBot.create_list(:merchant, 5)

    visit admin_merchants_path
    Merchant.all.each do |merchant|
      expect(page).to have_content(merchant.name)
    end
  end

  it 'has a name link to admin merchant show page' do 
    merchant = FactoryBot.create_list(:merchant,1)[0]
    visit admin_merchants_path

    click_link merchant.name

    expect(current_path).to eq("/admin/merchants/#{merchant.id}")
  end

  it 'lists merchants grouped by status' do 
    merchant1 = FactoryBot.create_list(:merchant, 1, status: 0)[0]
    merchant2 = FactoryBot.create_list(:merchant, 1, status: 0)[0]
    merchant3 = FactoryBot.create_list(:merchant, 1, status: 0)[0]
    merchant4 = FactoryBot.create_list(:merchant, 1, status: 1)[0]
    merchant5 = FactoryBot.create_list(:merchant, 1, status: 1)[0]
    merchant6 = FactoryBot.create_list(:merchant, 1, status: 1)[0]

    visit admin_merchants_path

    within(".enabled") do
      expect(page).to have_content(merchant1.name)
      expect(page).to have_content(merchant2.name)
      expect(page).to have_content(merchant3.name)
      expect(page).to_not have_content(merchant4.name)
      expect(page).to_not have_content(merchant5.name)
      expect(page).to_not have_content(merchant6.name)
    end

    within(".disabled") do
      expect(page).to_not have_content(merchant1.name)
      expect(page).to_not have_content(merchant2.name)
      expect(page).to_not have_content(merchant3.name)
      expect(page).to have_content(merchant4.name)
      expect(page).to have_content(merchant5.name)
      expect(page).to have_content(merchant6.name)
    end


  end 

  it 'lists the top five merchants and their total revenue' do 
    merchant1 = FactoryBot.create_list(:merchant, 1, name: 'merchant1')[0]
    merchant2 = FactoryBot.create_list(:merchant, 1, name: 'merchant2')[0]
    merchant3 = FactoryBot.create_list(:merchant, 1, name: 'merchant3')[0]
    merchant4 = FactoryBot.create_list(:merchant, 1, name: 'merchant4')[0]
    merchant5 = FactoryBot.create_list(:merchant, 1, name: 'merchant5')[0]
    merchant6 = FactoryBot.create_list(:merchant, 1, name: 'merchant6')[0]

    item1 = FactoryBot.create_list(:item, 1, merchant: merchant1)[0]
    item2 = FactoryBot.create_list(:item, 1, merchant: merchant2)[0]
    item3 = FactoryBot.create_list(:item, 1, merchant: merchant3)[0]
    item4 = FactoryBot.create_list(:item, 1, merchant: merchant4)[0]
    item5 = FactoryBot.create_list(:item, 1, merchant: merchant5)[0]
    item6 = FactoryBot.create_list(:item, 1, merchant: merchant6)[0]
        
    invoice1 = FactoryBot.create_list(:invoice, 1)[0]
    invoice2 = FactoryBot.create_list(:invoice, 1)[0]
    invoice3 = FactoryBot.create_list(:invoice, 1)[0]
    invoice4 = FactoryBot.create_list(:invoice, 1)[0]
    invoice5 = FactoryBot.create_list(:invoice, 1)[0]
    invoice6 = FactoryBot.create_list(:invoice, 1)[0]
        
    invoice_item1 = FactoryBot.create_list(:invoice_item, 1, invoice: invoice1, item: item1, quantity: 10, unit_price: 1000)[0]
    invoice_item2 = FactoryBot.create_list(:invoice_item, 1, invoice: invoice2, item: item2, quantity: 9, unit_price: 1000)[0]
    invoice_item3 = FactoryBot.create_list(:invoice_item, 1, invoice: invoice3, item: item3, quantity: 8, unit_price: 1000)[0]
    invoice_item4 = FactoryBot.create_list(:invoice_item, 1, invoice: invoice4, item: item4, quantity: 7, unit_price: 1000)[0]
    invoice_item5 = FactoryBot.create_list(:invoice_item, 1, invoice: invoice5, item: item5, quantity: 5, unit_price: 1000)[0]
    invoice_item6 = FactoryBot.create_list(:invoice_item, 1, invoice: invoice6, item: item6, quantity: 9, unit_price: 1000)[0]

    transaction1_0 = FactoryBot.create_list(:transaction, 1, invoice: invoice1, result:0)
    transaction1_1 = FactoryBot.create_list(:transaction, 1, invoice: invoice1, result:1)
    transaction2_1 = FactoryBot.create_list(:transaction, 1, invoice: invoice2, result:1)
    transaction3_0 = FactoryBot.create_list(:transaction, 1, invoice: invoice3, result:0)
    transaction4_0 = FactoryBot.create_list(:transaction, 1, invoice: invoice4, result:0)
    transaction5_1 = FactoryBot.create_list(:transaction, 1, invoice: invoice5, result:1)
    transaction5_0 = FactoryBot.create_list(:transaction, 1, invoice: invoice5, result:0)
    transaction6_0 = FactoryBot.create_list(:transaction, 1, invoice: invoice6, result:0)

    visit admin_merchants_path

    within("#top_5-#{merchant1.id}") do 
      expect(page).to have_content(merchant1.name)
      expect(page).to have_content(100.00)
    end
    within("#top_5-#{merchant6.id}") do 
      expect(page).to have_content(merchant6.name)
      expect(page).to have_content(90.00)
    end
    within("#top_5-#{merchant3.id}") do 
      expect(page).to have_content(merchant3.name)
      expect(page).to have_content(80.00)
    end
    within("#top_5-#{merchant4.id}") do 
      expect(page).to have_content(merchant4.name)
      expect(page).to have_content(70.00)
    end
    within("#top_5-#{merchant5.id}") do 
      expect(page).to have_content(merchant5.name)
      expect(page).to have_content(50.00)
    end
  end
end