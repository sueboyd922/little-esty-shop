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
end
