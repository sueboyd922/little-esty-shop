require 'rails_helper'

RSpec.describe 'admin invoices index page' do
  it 'shows all the invoices with a link to their show page' do
    @invoice1 = Invoice.all.sample
    @invoice2 = Invoice.all.sample
    @invoice3 = Invoice.all.sample
    @invoice4 = Invoice.all.sample
    @invoice5 = Invoice.all.sample
    require "pry"; binding.pry
    invoices = [@invoice1, @invoice2, @invoice3, @invoice4, @invoice5]

    invoices.each do |invoice|
      visit "/admin/invoices"
      click_on("#{invoice.id}")
      expect(current_path).to eq("/admin/invoices/#{invoice.id}")
    end
  end
end
