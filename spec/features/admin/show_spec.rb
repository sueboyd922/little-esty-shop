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
end
