require 'rails_helper'

RSpec.describe 'admin invoices index page' do
  it 'shows all the invoices with a link to their show page' do
    @customer = Customer.create(first_name: "Sally", last_name: "Jones")

    @invoice1 = @customer.invoices.create!(status: 0)
    @invoice2 = @customer.invoices.create!(status: 1)
    @invoice3 = @customer.invoices.create!(status: 0)
    @invoice4 = @customer.invoices.create!(status: 2)
    @invoice5 = @customer.invoices.create!(status: 1)

    Invoice.all.each do |invoice|
      visit "/admin/invoices"
      click_on("#{invoice.id}")
      expect(current_path).to eq("/admin/invoices/#{invoice.id}")
    end
  end
end
