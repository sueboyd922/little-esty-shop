require "rails_helper"

RSpec.describe "the admin dashboard" do
  it "shows a header to the dashboard" do
    visit "/admin"

    expect(page).to have_content("Welcome to Admin Dashboard")
  end

  it "shows links to access merchant and invoice index" do
    visit "/admin"

    expect(page).to have_link("Merchants Index")
    expect(page).to have_link("Invoices Index")
  end

  it "has a list of all incompleted invoices with their ID, which is a link to its show page" do
    customer_1 = Customer.create!(first_name: "John", last_name: "Smith")

    invoice_1 = customer_1.invoices.create!(status: "in progress")
    invoice_2 = customer_1.invoices.create!(status: "in progress")
    invoice_3 = customer_1.invoices.create!(status: "completed")
    invoice_4 = customer_1.invoices.create!(status: "cancelled")

    visit "/admin"

    within(".incompleted_invoices") do
      expect(page).to have_content(invoice_1.id)
      expect(page).to have_content(invoice_2.id)
      expect(page).to_not have_content(invoice_3.id)
      expect(page).to_not have_content(invoice_4.id)
      expect(page).to have_link("Invoice: #{invoice_2.id}")
    end
  end

  it "list of incompleted invoices is ordered from least recent to most recent" do
    customer_1 = Customer.create!(first_name: "Person 1", last_name: "Mcperson 1")

    invoice_1 = customer_1.invoices.create!(status: "in progress", created_at: "2022-04-10")
    invoice_2 = customer_1.invoices.create!(status: "in progress", created_at: "2022-04-09")
    invoice_3 = customer_1.invoices.create!(status: "in progress", created_at: "2022-04-08")
    visit "/admin"

    within(".incompleted_invoices") do
      expect(invoice_3.created_at.strftime("%A, %B %d, %Y")).to appear_before(invoice_2.created_at.strftime("%A, %B %d, %Y"))
      expect(invoice_2.created_at.strftime("%A, %B %d, %Y")).to appear_before(invoice_1.created_at.strftime("%A, %B %d, %Y"))
    end
  end

  it 'has a list of the top 5 customers' do
    FactoryBot.create_list(:customer, 7)
    customer_1 = Customer.all[0]
    customer_2 = Customer.all[1]
    customer_3 = Customer.all[2]
    customer_4 = Customer.all[3]
    customer_5 = Customer.all[4]
    customer_6 = Customer.all[5]
    customer_7 = Customer.all[6]

    merchant = FactoryBot.create_list(:merchant, 1).first

    FactoryBot.create_list(:item, 2, merchant: merchant)
    item_1 = Item.all[0]
    item_2 = Item.all[1]

    Customer.all.each do |customer|
      FactoryBot.create_list(:invoice, 2, customer: customer)
    end

    invoice_0 = Invoice.all[0]
    invoice_1 = Invoice.all[1]
    invoice_2 = Invoice.all[2]
    invoice_3 = Invoice.all[3]
    invoice_4 = Invoice.all[4]
    invoice_5 = Invoice.all[5]
    invoice_6 = Invoice.all[6]
    invoice_7 = Invoice.all[7]
    invoice_8 = Invoice.all[8]
    invoice_9 = Invoice.all[9]
    invoice_10 = Invoice.all[10]
    invoice_11 = Invoice.all[11]
    invoice_12 = Invoice.all[12]
    invoice_13 = Invoice.all[13]

    FactoryBot.create_list(:invoice_item, 1, item: item_1, unit_price: 5400, quantity: 1, invoice: invoice_0)
    FactoryBot.create_list(:invoice_item, 1, item: item_2, unit_price: 3000, quantity: 1, invoice: invoice_0)
    FactoryBot.create_list(:invoice_item, 1, item: item_1, unit_price: 5400, quantity: 2, invoice: invoice_0) #invoice_0 total: 19200
    FactoryBot.create_list(:invoice_item, 1, item: item_1, unit_price: 5400, quantity: 1, invoice: invoice_1) #invoice_1 total: 5400
    #customer_1 total: 246000

    FactoryBot.create_list(:invoice_item, 1, item: item_1, unit_price: 5400, quantity: 1, invoice: invoice_2) #invoice_2 total: 5400
    FactoryBot.create_list(:invoice_item, 1, item: item_2, unit_price: 5400, quantity: 1, invoice: invoice_3)
    FactoryBot.create_list(:invoice_item, 1, item: item_1, unit_price: 3000, quantity: 4, invoice: invoice_3) #invoice_3 total: 17,400
    #customer_2 total: 22800

    FactoryBot.create_list(:invoice_item, 1, item: item_2, unit_price: 5400, quantity: 3, invoice: invoice_4) #invoice_4 total: 16,200
    #customer_3 total: 16,200

    FactoryBot.create_list(:invoice_item, 1, item: item_1, unit_price: 3000, quantity: 1, invoice: invoice_6)
    FactoryBot.create_list(:invoice_item, 1, item: item_2, unit_price: 5400, quantity: 1, invoice: invoice_6) #invoice_6 total: 8400
    FactoryBot.create_list(:invoice_item, 1, item: item_1, unit_price: 3000, quantity: 1, invoice: invoice_7) #invoice_7 total: 3000
    #customer_4 total: 11400

    FactoryBot.create_list(:invoice_item, 1, item: item_1, unit_price: 5400, quantity: 1, invoice: invoice_9) #invoice_9 total: 5400
    #customer_5 total: 5400

    FactoryBot.create_list(:invoice_item, 1, item: item_1, unit_price: 5400, quantity: 5, invoice: invoice_10) #invoice_10 total: 27000
    FactoryBot.create_list(:invoice_item, 1, item: item_1, unit_price: 5400, quantity: 1, invoice: invoice_11)
    FactoryBot.create_list(:invoice_item, 1, item: item_1, unit_price: 5400, quantity: 2, invoice: invoice_11)
    FactoryBot.create_list(:invoice_item, 1, item: item_2, unit_price: 3000, quantity: 1, invoice: invoice_11) #invoice_11 total: 19200
    #customer_6 total: 46200

    FactoryBot.create_list(:invoice_item, 1, item: item_1, unit_price: 5400, quantity: 2, invoice: invoice_13) #invoice_13 total: 10800
    #customer_7 total: 10800

    #customer_1 transactions total 3, 2 success, spent: 24600
    FactoryBot.create_list(:transaction, 1, invoice: invoice_0, result: 1)
    FactoryBot.create_list(:transaction, 1, invoice: invoice_0, result: 0)
    FactoryBot.create_list(:transaction, 1, invoice: invoice_1, result: 0)
    #customer_2 transactions total 3, 1 success spent: 5400
    FactoryBot.create_list(:transaction, 1, invoice: invoice_2, result: 0)
    FactoryBot.create_list(:transaction, 1, invoice: invoice_3, result: 1)
    FactoryBot.create_list(:transaction, 1, invoice: invoice_3, result: 1)
    #customer_3 transactions total 1 1 success, spent: 16200
    FactoryBot.create_list(:transaction, 1, invoice: invoice_4, result: 0)
    #customer_4 transactions total 4 2 success spent: 11400
    FactoryBot.create_list(:transaction, 6, invoice: invoice_3, result: 0)
    FactoryBot.create_list(:transaction, 7, invoice: invoice_3, result: 1)
    FactoryBot.create_list(:transaction, 7, invoice: invoice_3, result: 1)
    FactoryBot.create_list(:transaction, 7, invoice: invoice_3, result: 0)
    #customer_5 transactions total: 2, 2 failed spent: 0
    FactoryBot.create_list(:transaction, 1, invoice: invoice_9, result: 1)
    FactoryBot.create_list(:transaction, 1, invoice: invoice_9, result: 1)
    #customer_6 transactions total: 3, 2 successful spent 46200
    FactoryBot.create_list(:transaction, 1, invoice: invoice_10, result: 0)
    FactoryBot.create_list(:transaction, 1, invoice: invoice_11, result: 1)
    FactoryBot.create_list(:transaction, 1, invoice: invoice_11, result: 0)
    #customer_7 transactions total: 1 1 success spent: 10800
    FactoryBot.create_list(:transaction, 1, invoice: invoice_3, result: 0)

    visit "/admin"
    expect(page).to have_content("Top 5 Customers")
    within ".cust-#{customer_6.id}" do
      expect(page).to have_content(customer_6.name)
      expect(page).to have_content(2)
    end
    within ".cust-#{customer_3.id}" do
      expect(page).to have_content(customer_3.name)
      expect(page).to have_content(1)
    end
    within ".cust-#{customer_1.id}" do
      expect(page).to have_content(customer_1.name)
      expect(page).to have_content(2)
    end
    within ".top-customers" do
      expect(customer_6.name).to appear_before(customer_1.name)
      expect(customer_1.name).to appear_before(customer_3.name)
      expect(customer_3.name).to appear_before(customer_4.name)
      expect(customer_4.name).to appear_before(customer_7.name)
      expect(page).not_to have_content(customer_2.name)
      expect(page).not_to have_content(customer_5.name)
    end
  end

end
