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

  it "has a list of the top 5 customers" do
    FactoryBot.create_list(:customer, 7)
    customer_1 = Customer.all[0]
    customer_2 = Customer.all[1]
    customer_3 = Customer.all[2]
    customer_4 = Customer.all[3]
    customer_5 = Customer.all[4]
    customer_6 = Customer.all[5]
    customer_7 = Customer.all[6]

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
    invoice_14 = FactoryBot.create_list(:invoice, 1, customer: customer_1).first
    invoice_15 = FactoryBot.create_list(:invoice, 1, customer: customer_1).first
    invoice_16 = FactoryBot.create_list(:invoice, 1, customer: customer_6).first
    invoice_17 = FactoryBot.create_list(:invoice, 1, customer: customer_7).first
    invoice_18 = FactoryBot.create_list(:invoice, 1, customer: customer_7).first
    invoice_19 = FactoryBot.create_list(:invoice, 1, customer: customer_7).first
    invoice_20 = FactoryBot.create_list(:invoice, 1, customer: customer_7).first
    invoice_21 = FactoryBot.create_list(:invoice, 1, customer: customer_7).first
    invoice_22 = FactoryBot.create_list(:invoice, 1, customer: customer_1).first
    invoice_23 = FactoryBot.create_list(:invoice, 1, customer: customer_2).first
    invoice_24 = FactoryBot.create_list(:invoice, 1, customer: customer_2).first
    invoice_25 = FactoryBot.create_list(:invoice, 1, customer: customer_6).first

    # FactoryBot.create_list(:invoice, 8, customer: customer_1)
    # 3.times do
    #   FactoryBot.create_list(:transaction, 3, invoice: customer_1.invoices.sample, result: 1)
    # end
    # customer_1.invoices.each do |invoice|
    #   FactoryBot.create_list(:transaction, 1, invoice: invoice, result: 0)
    # end

    # customer_1 transactions total 7, 5 success
    FactoryBot.create_list(:transaction, 1, invoice: invoice_0, result: 1)
    FactoryBot.create_list(:transaction, 1, invoice: invoice_0, result: 0)
    FactoryBot.create_list(:transaction, 1, invoice: invoice_14, result: 0)
    FactoryBot.create_list(:transaction, 1, invoice: invoice_15, result: 1)
    FactoryBot.create_list(:transaction, 1, invoice: invoice_15, result: 0)
    FactoryBot.create_list(:transaction, 1, invoice: invoice_1, result: 0)
    FactoryBot.create_list(:transaction, 1, invoice: invoice_22, result: 0)
    # customer_2 transactions total 3, 3 success
    FactoryBot.create_list(:transaction, 1, invoice: invoice_2, result: 0)
    FactoryBot.create_list(:transaction, 1, invoice: invoice_3, result: 1)
    FactoryBot.create_list(:transaction, 1, invoice: invoice_3, result: 1)
    FactoryBot.create_list(:transaction, 1, invoice: invoice_23, result: 0)
    FactoryBot.create_list(:transaction, 1, invoice: invoice_24, result: 1)
    FactoryBot.create_list(:transaction, 1, invoice: invoice_24, result: 0)
    # customer_3 transactions total 1 1 success
    FactoryBot.create_list(:transaction, 1, invoice: invoice_4, result: 0)
    # customer_4 transactions total 4 2 success
    FactoryBot.create_list(:transaction, 1, invoice: invoice_6, result: 0)
    FactoryBot.create_list(:transaction, 1, invoice: invoice_7, result: 1)
    FactoryBot.create_list(:transaction, 1, invoice: invoice_7, result: 1)
    FactoryBot.create_list(:transaction, 1, invoice: invoice_7, result: 0)
    # customer_5 transactions total: 2, 0 success
    FactoryBot.create_list(:transaction, 1, invoice: invoice_9, result: 1)
    FactoryBot.create_list(:transaction, 1, invoice: invoice_9, result: 1)
    # customer_6 transactions total: 5, 4 successful
    FactoryBot.create_list(:transaction, 1, invoice: invoice_10, result: 0)
    FactoryBot.create_list(:transaction, 1, invoice: invoice_11, result: 1)
    FactoryBot.create_list(:transaction, 1, invoice: invoice_11, result: 0)
    FactoryBot.create_list(:transaction, 1, invoice: invoice_16, result: 0)
    FactoryBot.create_list(:transaction, 1, invoice: invoice_25, result: 0)
    # customer_7 transactions total: 8 6 success
    FactoryBot.create_list(:transaction, 1, invoice: invoice_13, result: 0)
    FactoryBot.create_list(:transaction, 1, invoice: invoice_17, result: 0)
    FactoryBot.create_list(:transaction, 1, invoice: invoice_18, result: 1)
    FactoryBot.create_list(:transaction, 1, invoice: invoice_18, result: 0)
    FactoryBot.create_list(:transaction, 1, invoice: invoice_19, result: 1)
    FactoryBot.create_list(:transaction, 1, invoice: invoice_19, result: 1)
    FactoryBot.create_list(:transaction, 1, invoice: invoice_19, result: 0)
    FactoryBot.create_list(:transaction, 1, invoice: invoice_20, result: 0)
    FactoryBot.create_list(:transaction, 1, invoice: invoice_21, result: 0)

    visit "/admin"
    expect(page).to have_content("Top 5 Customers")
    within ".cust-#{customer_6.id}" do
      expect(page).to have_content(customer_6.last_name)
      expect(page).to have_content(4)
    end
    within ".cust-#{customer_7.id}" do
      expect(page).to have_content(customer_7.last_name)
      expect(page).to have_content(6)
    end
    within ".cust-#{customer_1.id}" do
      expect(page).to have_content(customer_1.last_name)
      expect(page).to have_content(5)
    end
    within ".top-customers" do
      expect(customer_7.first_name).to appear_before(customer_1.first_name)
      expect(customer_1.first_name).to appear_before(customer_6.first_name)
      expect(customer_6.first_name).to appear_before(customer_2.first_name)
      expect(customer_2.first_name).to appear_before(customer_4.first_name)
      expect(page).not_to have_content(customer_3.first_name)
      expect(page).not_to have_content(customer_5.first_name)
    end
  end
end
