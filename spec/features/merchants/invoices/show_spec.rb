require 'rails_helper'

RSpec.describe 'merchant invoices show page' do
  it "has the total revenue generated and total discounted revenue" do
    merchant1 = Merchant.create!(name: "Joyce's Things")
    merchant2 = Merchant.create!(name: "Samwise's Things")

    item1 = merchant1.items.create!(name: "Bowtie", description: "it looks cool", unit_price: 1200)
    item2 = merchant1.items.create!(name: "Earrings", description: "it looks cool", unit_price: 2000)

    item3 = merchant2.items.create!(name: "Stuffed elephant", description: "fun for kids", unit_price: 1550)

    customer = Customer.create!(first_name: "Jamie", last_name: "Personname")

    invoice = customer.invoices.create(status: "in progress")

    invoice_item1 = InvoiceItem.create!(item: item1, invoice: invoice, quantity: 5, unit_price: 1300, status: "packaged")
    invoice_item2 = InvoiceItem.create!(item: item2, invoice: invoice, quantity: 5, unit_price: 2000, status: "shipped")
    invoice_item3 = InvoiceItem.create!(item: item3, invoice: invoice, quantity: 7, unit_price: 1550, status: "pending")

    discount = merchant1.discounts.create!(quantity: 5, percent_discount: 10)
    discount2 = merchant2.discounts.create!(quantity: 10, percent_discount: 15)

    visit "merchants/#{merchant1.id}/invoices/#{invoice.id}"

    expect(page).to have_content("Total Revenue After Discount: $148.50")
    expect(page).not_to have_content("Total Revenue After Discount: $165.00")
  end

  it 'applies the higher percentage discount' do
    merchant1 = Merchant.create!(name: "Joyce's Things")
    merchant2 = Merchant.create!(name: "Samwise's Things")

    item1 = merchant1.items.create!(name: "Bowtie", description: "it looks cool", unit_price: 1200)
    item2 = merchant1.items.create!(name: "Earrings", description: "it looks cool", unit_price: 2000)

    item3 = merchant2.items.create!(name: "Stuffed elephant", description: "fun for kids", unit_price: 1550)

    customer = Customer.create!(first_name: "Jamie", last_name: "Personname")

    invoice = customer.invoices.create(status: "in progress")

    invoice_item1 = InvoiceItem.create!(item: item1, invoice: invoice, quantity: 10, unit_price: 1300, status: "packaged")
    invoice_item2 = InvoiceItem.create!(item: item2, invoice: invoice, quantity: 5, unit_price: 2000, status: "shipped")
    invoice_item3 = InvoiceItem.create!(item: item3, invoice: invoice, quantity: 7, unit_price: 1550, status: "pending")

    discount = merchant1.discounts.create!(quantity: 5, percent_discount: 10)
    discount = merchant1.discounts.create!(quantity: 10, percent_discount: 7)
    discount2 = merchant2.discounts.create!(quantity: 10, percent_discount: 15)

    visit "merchants/#{merchant1.id}/invoices/#{invoice.id}"

    expect(page).to have_content("Total Revenue After Discount: $207.00")
    expect(page).not_to have_content("Total Revenue After Discount: $230.00")
  end

  it 'shows a link to the discount show page if the item has a discount applied' do
    merchant1 = Merchant.create!(name: "Joyce's Things")
    merchant2 = Merchant.create!(name: "Samwise's Things")

    item1 = merchant1.items.create!(name: "Bowtie", description: "it looks cool", unit_price: 1200)
    item2 = merchant1.items.create!(name: "Earrings", description: "it looks cool", unit_price: 2000)

    item3 = merchant2.items.create!(name: "Stuffed elephant", description: "fun for kids", unit_price: 1550)

    customer = Customer.create!(first_name: "Jamie", last_name: "Personname")

    invoice = customer.invoices.create(status: "in progress")

    invoice_item1 = InvoiceItem.create!(item: item1, invoice: invoice, quantity: 10, unit_price: 1300, status: "packaged")
    invoice_item2 = InvoiceItem.create!(item: item2, invoice: invoice, quantity: 3, unit_price: 2000, status: "shipped")
    invoice_item3 = InvoiceItem.create!(item: item3, invoice: invoice, quantity: 16, unit_price: 1550, status: "pending")

    discount = merchant1.discounts.create!(quantity: 5, percent_discount: 10)
    discount2 = merchant2.discounts.create!(quantity: 15, percent_discount: 15)

    visit "merchants/#{merchant1.id}/invoices/#{invoice.id}"

    within "#invoice_item-#{invoice_item1.id}" do
      expect(page).not_to have_content("Discounts: None")
      click_on("Applied")
      expect(current_path).to eq("/merchants/#{merchant1.id}/discounts/#{discount.id}")
    end

    visit "/merchants/#{merchant1.id}/invoices/#{invoice.id}"

    within "#invoice_item-#{invoice_item2.id}" do
      expect(page).not_to have_button("Applied")
      expect(page).to have_content("Discounts: None")
    end
  end
end
