require 'rails_helper'

RSpec.describe 'invoice show page' do
  before :each do
    @merchant1 = Merchant.create!(name: "Schroeder-Jerde")
    @merchant2 = Merchant.create!(name: "Schroeder-Jerde2")
    @item1 = @merchant1.items.create!(name: "Item Qui Esse", description: "Nihil autem sit odio inventore deleniti. Est lauda...", unit_price: 75107)
    @item2 = @merchant1.items.create!(name: "Item Autem Minima", description: "Cumque consequuntur ad. Fuga tenetur illo molestia...", unit_price: 67076)
    @item3 = @merchant1.items.create!(name: "Item Ea Voluptatum", description: "Sunt officia eum qui molestiae. Nesciunt quidem cu...", unit_price: 32301)
    @item4 = @merchant2.items.create!(name: "Yabba Dabba", description: "Eat your vitamins", unit_price: 30000)
    @customer1 = Customer.create!(first_name: "Joey", last_name: "Ondricka")
    @customer2 = Customer.create!(first_name: "Cory", last_name: "Bethune")
    @invoice1 = Invoice.create!(customer_id: @customer1.id, status: "cancelled")
    @invoice2 = Invoice.create!(customer_id: @customer1.id, status: "in progress")
    @invoice3 = Invoice.create!(customer_id: @customer2.id, status: "in progress")
    @invoice_item1 = InvoiceItem.create!(item_id: @item1.id, invoice_id: @invoice1.id, quantity: 1, unit_price: 75100, status: "shipped",)
    @invoice_item2 = InvoiceItem.create!(item_id: @item2.id, invoice_id: @invoice2.id, quantity: 3, unit_price: 200000, status: "packaged",)
    @invoice_item3 = InvoiceItem.create!(item_id: @item3.id, invoice_id: @invoice2.id, quantity: 1, unit_price: 32301, status: "pending",)
    @invoice_item4 = InvoiceItem.create!(item_id: @item4.id, invoice_id: @invoice3.id, quantity: 5, unit_price: 10000, status: "pending",)

  end

  it "displays invoice information on the invoice show page" do
    visit "/merchants/#{@merchant1.id}/invoices/#{@invoice1.id}"

    expect(page).to have_content(@invoice1.id)
    expect(page).to have_content(@invoice1.status)
    expect(page).to have_content(@invoice1.created_at.strftime("%A, %B %d, %Y"))
    expect(page).to have_content(@invoice1.id)
    expect(page).to have_content(@customer1.first_name)
    expect(page).to have_content(@customer1.last_name)
  end

  it "display invoice item information on the invoice show page" do
    visit "/merchants/#{@merchant1.id}/invoices/#{@invoice3.id}"

    within("#invoice_item-#{@invoice_item4.id}") do
      expect(page).to have_content(@invoice_item4.quantity)
      expect(page).to have_content('$100.00')
      expect(find_field('status').value).to eq(@invoice_item4.status)
      expect(page).to have_content(@item4.name)
    end
    expect(page).to have_no_content(@item3.name)
    expect(page).to have_no_content(@item2.name)
    expect(page).to have_no_content(@item1.name)
  end

  it 'displays the total revenue that will be generated from all items on the invoice' do
    visit "/merchants/#{@merchant1.id}/invoices/#{@invoice2.id}"

    expect(page).to have_content('$6323.01')
  end

  it 'can update invoice item status via a select field' do
    visit "/merchants/#{@merchant1.id}/invoices/#{@invoice2.id}"
    within("#invoice_item-#{@invoice_item2.id}") do
      expect(find_field('status').value).to eq('packaged')
      select 'Shipped'
      click_button 'Update Item Status'
      expect(current_path).to eq("/merchants/#{@merchant1.id}/invoices/#{@invoice2.id}")
      expect(find_field('status').value).to eq('shipped')
    end
  end
end
