require "rails_helper"

RSpec.describe "admin invoices show page" do
  before(:each) do
    @customer = Customer.create(first_name: "Sally", last_name: "Jones")
    @customer2 = Customer.create!(first_name: "Abel", last_name: "Bloomfield")
    @invoice1 = @customer.invoices.create!(status: 0)
    @invoice2 = @customer.invoices.create!(status: 1)
    @invoice3 = @customer.invoices.create!(status: 0)
    @invoice4 = @customer2.invoices.create!(status: 2)
  end

  it "shows all the information for an invoice" do
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

  it "shows all the info for the invoices items" do
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

  it "shows the total revenue generated by an invoice" do
    merchant = Merchant.create!(name: "Frodo's Furniture")
    item1 = merchant.items.create!(name: "Chair", description: "sit on it", unit_price: 5400)
    item2 = merchant.items.create!(name: "Bed", description: "sleep on it", unit_price: 95050)
    item3 = merchant.items.create!(name: "Dresser", description: "put things in it", unit_price: 34999)

    merchant2 = Merchant.create!(name: "Don's Drapes")
    item4 = merchant2.items.create!(name: "Full curtains", description: "block the sun", unit_price: 5075)
    item5 = merchant2.items.create!(name: "curtain rod", description: "hang the curtains", unit_price: 2000)

    customer = Customer.create!(first_name: "Sam", last_name: "McCoy")
    invoice = customer.invoices.create!(status: "in progress")
    invoice2 = customer.invoices.create!(status: "completed")

    InvoiceItem.create!(item: item1, invoice: invoice, quantity: 6, unit_price: 5400, status: 0)
    InvoiceItem.create!(item: item2, invoice: invoice, quantity: 1, unit_price: 94050, status: 1)
    InvoiceItem.create!(item: item3, invoice: invoice, quantity: 2, unit_price: 34000, status: 2)
    InvoiceItem.create!(item: item4, invoice: invoice, quantity: 4, unit_price: 5070, status: 2)
    InvoiceItem.create!(item: item4, invoice: invoice2, quantity: 2, unit_price: 5070, status: 0)

    visit "/admin/invoices/#{invoice.id}"
    expect(page).to have_content("Total Revenue: $2147.30")
    expect(page).not_to have_content("Total Revenue: $2248.70")

    visit "/admin/invoices/#{invoice2.id}"
    expect(page).to have_content("Total Revenue: $101.40")
  end

  it "displays invoice status and allows edits" do
    customer3 = Customer.create!(first_name: "Ash", last_name: "Barty")
    invoice5 = customer3.invoices.create!(status: 0)
    visit "/admin/invoices/#{invoice5.id}"

    expect(page).to have_field(:status)

    select "Completed", from: :status
    click_on("Update Invoice Status")

    expect(current_path).to eq("/admin/invoices/#{invoice5.id}")

    expect(page).to have_field(:status, with: "completed")
    expect(current_path).to eq("/admin/invoices/#{invoice5.id}")
  end

  it 'shows the discounted revenue of an invoice' do
    customer = Customer.create!(first_name: "Jessie", last_name: "Thomas")

    invoice = customer.invoices.create!(status: 0)

    merchant1 = Merchant.create!(name: "Patsy's Pies")
    merchant2 = Merchant.create!(name: "Jungle Jims")
    merchant3 = Merchant.create!(name: "Holistic Holly")

    item1 = merchant1.items.create!(name: "Applie Pie", description: "apple", unit_price: 1300)
    item2 = merchant1.items.create!(name: "Pumpkin Pie", description: "Pumpkin", unit_price: 1300)

    item3 = merchant2.items.create!(name: "Swingset", description: "fun", unit_price: 22300)

    item4 = merchant3.items.create!(name: "Incense", description: "nose smells", unit_price: 600)
    item5 = merchant3.items.create!(name: "Lighter", description: "fire", unit_price: 1000)

    InvoiceItem.create!(item: item1, invoice: invoice, quantity: 5, unit_price: 1300, status: 1)
    InvoiceItem.create!(item: item2, invoice: invoice, quantity: 10, unit_price: 1300, status: 1)
    InvoiceItem.create!(item: item3, invoice: invoice, quantity: 1, unit_price: 22300, status: 1)
    InvoiceItem.create!(item: item4, invoice: invoice, quantity: 15, unit_price: 600, status: 1)
    InvoiceItem.create!(item: item5, invoice: invoice, quantity: 3, unit_price: 1000, status: 1)

    discount1 = merchant1.discounts.create!(quantity: 5, percent_discount: 10)
    discount2 = merchant1.discounts.create!(quantity: 10, percent_discount: 15)
    discount3 = merchant2.discounts.create!(quantity: 2, percent_discount: 50)
    discount4 = merchant3.discounts.create!(quantity: 10, percent_discount: 18)

    visit "/admin/invoices/#{invoice.id}"

    expect(page).to have_content("Total Revenue: $538.00")
    expect(page).to have_content("Total Revenue After Discount: $495.80")
  end
end
