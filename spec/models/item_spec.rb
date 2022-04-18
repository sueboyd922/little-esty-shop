require "rails_helper"

RSpec.describe Item, type: :model do
  describe "associations" do
    it { should have_many :invoice_items }
    it { should belong_to :merchant }
    it { should have_many(:invoices).through(:invoice_items) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:unit_price) }
    it { should validate_numericality_of(:unit_price).only_integer }
    it { should validate_numericality_of(:unit_price).is_greater_than(0) }
    it { should define_enum_for(:status).with([:enabled, :disabled]) }
  end

  describe "default" do
    it "has a default of enabled" do
      merchant = Merchant.create!(name: "Sam's Toys")
      item = merchant.items.create!(name: "Potato gun", description: "Shoots potatoes", unit_price: 1800)

      expect(item.status).to eq("enabled")
    end
  end
  describe "best_day" do
    it "returns the date associated with the items highest revenue invoice" do
      merchant_1 = Merchant.create!(name: "Stuff and Things")
      customer_1 = Customer.create!(first_name: "Greta", last_name: "Garbo")
      item_1 = merchant_1.items.create!(name: "Stuff", description: "The stuff of stuff and things", unit_price: 1345)
      invoice_1 = customer_1.invoices.create!(status: "completed", created_at: DateTime.new(2022, 4, 17))
      invoice_item_1 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_1.id, quantity: 1, unit_price: 1345, status: "shipped")
      invoice_2 = customer_1.invoices.create!(status: "completed", created_at: DateTime.new(2022, 5, 18))
      invoice_item_2 = InvoiceItem.create!(invoice_id: invoice_2.id, item_id: item_1.id, quantity: 1, unit_price: 1256, status: "shipped")
      transcation_1 = invoice_1.transactions.create!(credit_card_number: "4654405418249632", result: "success")
      transcation_2 = invoice_2.transactions.create!(credit_card_number: "4654405418249634", result: "success")

      expect(item_1.best_day).to eq(DateTime.new(2022, 4, 17))
      expect(item_1.best_day).to_not eq(DateTime.new(2022, 5, 18))
    end
  end
end
