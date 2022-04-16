require 'rails_helper'

RSpec.describe 'admin invoices show page' do
  before (:each) do
    @customer = Customer.create(first_name: "Sally", last_name: "Jones")
    @customer2 = Customer.create!(first_name: "Abel", last_name: "Bloomfield")
    @invoice1 = @customer.invoices.create!(status: 0)
    @invoice2 = @customer.invoices.create!(status: 1)
    @invoice3 = @customer.invoices.create!(status: 0)
    @invoice4 = @customer2.invoices.create!(status: 2)
  end

  it 'shows all the information for an invoice' do
    today = Time.now.strftime("%A, %B %d, %Y")

    visit "admin/invoices/#{@invoice1.id}"

    expect(page).to have_content("Sally Jones")
    expect(page).to have_content(today)
    expect(page).to have_content("cancelled")
    expect(page).to have_content(@invoice1.id)
    expect(page).not_to have_content(@invoice3.id)
    expect(page).not_to have_content("Abel Bloomfield")
    expect(page).not_to have_content("completed")
  end

  it 'shows all the info for the invoices items' do
    @merchant1 = Merchant.create!(name: "Cory's Crustables")
    @merchant2 = Merchant.create!(name: "Kim's Kolsch")

    @item1 = @merchant1.items.create!(name: "PB & J", description: "a sandwich: all crusts", unit_price: 1300)
    @item2 = @merchant2.items.create!(name: "Brewski", description: "not a kloish", unit_price: 2150)
    @item3 = @merchant2.items.create!(name: "Beerski", description: "also not a kloish or a kolsch...it's an API", unit_price: 2550)

    InvoiceItem.create!(invoice_id: @invoice1.id, item_id: @item1.id, quantity: 3, unit_price: 1300, status: 0)
    InvoiceItem.create!(invoice_id: @invoice1.id, item_id: @item2.id, quantity: 2, unit_price: 2450, status: 1)
    InvoiceItem.create!(invoice_id: @invoice2.id, item_id: @item3.id, quantity: 4, unit_price: 2550, status: 2)

    visit "/admin/invoices/#{@invoice1.id}"

    within ".item-#{@item1.id}" do
      expect(page).to have_content(@item1.name)
      expect(page).to have_content("packaged")
      expect(page).to have_content(3)
      expect(page).to have_content("$13.00")
      expect(page).not_to have_content(@item2.name)
    end

    within ".item-#{@item2.id}" do
      expect(page).to have_content(@item2.name)
      expect(page).to have_content("pending")
      expect(page).to have_content(2)
      expect(page).to have_content("$24.50")
      expect(page).not_to have_content(@item1.name)
    end

    expect(page).not_to have_content(@item3.name)
  end


end
