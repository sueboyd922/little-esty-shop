require 'rails_helper'

RSpec.describe 'admin invoices show page' do
  it 'shows all the information for an invoice' do
    @customer = Customer.create(first_name: "Sally", last_name: "Jones")
    @customer2 = Customer.create!(first_name: "Abel", last_name: "Bloomfield")
    @invoice1 = @customer.invoices.create!(status: 0)
    @invoice2 = @customer.invoices.create!(status: 1)
    @invoice3 = @customer.invoices.create!(status: 0)
    @invoice4 = @customer2.invoices.create!(status: 2)

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
end
