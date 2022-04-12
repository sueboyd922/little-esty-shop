require "rails_helper"

RSpec.describe Invoice, type: :model do
  describe "relationships" do
    it { should belong_to(:customer) }
    it { should have_many(:invoice_items) }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many(:transactions) }
  end

  describe "validations" do
    let!(:status) { %i[cancelled in_progress completed] }
  end

  describe "instance methods" do
  end

  describe "class methods" do
    it "can return all invoices that are incomplete aka 'in progress'" do
      customer_1 = Customer.create!(first_name: "Burt", last_name: "Bacharach")

      invoice_1 = customer_1.invoices.create!(status: "in progress")
      invoice_2 = customer_1.invoices.create!(status: "in progress")
      invoice_3 = customer_1.invoices.create!(status: "cancelled")
      invoice_4 = customer_1.invoices.create!(status: "completed")
      invoice_5 = customer_1.invoices.create!(status: "completed")

      expect(Invoice.not_completed).to eq([invoice_1, invoice_2])
    end
  end
end
