require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do

  describe 'relationships' do
    it { should belong_to :invoice }
    it { should belong_to :item }
    it { should have_one(:merchant).through(:item) }
    it { should have_many(:discounts).through(:merchant) }
  end

  describe 'validations' do
    it { should validate_presence_of(:quantity) }
    it { should validate_presence_of(:unit_price) }
    it { should validate_presence_of(:status) }
    it { should validate_numericality_of(:quantity).only_integer }
    it { should validate_numericality_of(:unit_price).only_integer }
    it { should validate_numericality_of(:quantity).is_greater_than(0) }
    it { should validate_numericality_of(:unit_price).is_greater_than(0) }

    let!(:status) { %i[packaged pending shipped]}
  end

  describe 'instance methods' do
    it '.applied_discount' do
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

      discount1 = merchant1.discounts.create!(quantity: 5, percent_discount: 10)
      discount2 = merchant2.discounts.create!(quantity: 10, percent_discount: 15)
      discount3 = merchant1.discounts.create!(quantity: 3, percent_discount: 15)

      expect(invoice_item1.discounts).to eq([discount1, discount3])
      expect(invoice_item1.applied_discount).to eq(discount3)
    end
  end
end
