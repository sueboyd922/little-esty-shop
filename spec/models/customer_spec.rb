require "rails_helper"

RSpec.describe Customer, type: :model do

  describe 'associations' do
	  it {should have_many :invoices}
  end

  describe 'validations' do
    it { should validate_presence_of(:first_name)}
    it { should validate_presence_of(:last_name)}
  end

  # describe 'class methods' do
  #   before :each do
  #     @merchant1 = Merchant.create!(name: "Schroeder-Jerde")
  #     @item1 = @merchant1.items.create!(name: "Item Qui Esse", description: "Nihil autem sit odio inventore deleniti. Est lauda...", unit_price: 75107)
  #     @item2 = @merchant1.items.create!(name: "Item Autem Minima", description: "Cumque consequuntur ad. Fuga tenetur illo molestia...", unit_price: 67076)
  #     @item3 = @merchant1.items.create!(name: "Item Ea Voluptatum", description: "Sunt officia eum qui molestiae. Nesciunt quidem cu...", unit_price: 32301)
  #     @customer1 = Customer.create!(first_name: "Joey", last_name: "Ondricka")
  #     @invoice1 = Invoice.create!(customer_id: @customer1.id, status: "cancelled")
  #     @invoice2 = Invoice.create!(customer_id: @customer1.id, status: "in progress")
  #     @invoice_item1 = InvoiceItem.create!(item_id: @item1.id, invoice_id: @invoice1.id, quantity: 1, unit_price: 75100, status: "shipped",)
  #     @invoice_item2 = InvoiceItem.create!(item_id: @item2.id, invoice_id: @invoice2.id, quantity: 3, unit_price: 200000, status: "packaged",)
  #     @invoice_item3 = InvoiceItem.create!(item_id: @item3.id, invoice_id: @invoice2.id, quantity: 1, unit_price: 32301, status: "pending",)
  #     @transaction1 = Transaction.create!(invoice_id: @invoice1.id, credit_card_number: "4654405418249632", credit_card_expiration_date: nil, result: "success")
  #   end
  #
  #   describe '#find_by_merchant_id' do
  #     it "returns all the customers associated with a merchant" do
  #       expect(Customer.find_by_merchant_id(@merchant1.id)).to eq([@customer1])
  #     end
  #   end
  # end
end
