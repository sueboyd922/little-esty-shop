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
      it ".total_revenue" do
        @merchant1 = Merchant.create!(name: "Schroeder-Jerde")
        @item1 = @merchant1.items.create!(name: "Item Qui Esse", description: "Nihil autem sit odio inventore deleniti. Est lauda...", unit_price: 75107)
        @item2 = @merchant1.items.create!(name: "Item Autem Minima", description: "Cumque consequuntur ad. Fuga tenetur illo molestia...", unit_price: 67076)
        @item3 = @merchant1.items.create!(name: "Item Ea Voluptatum", description: "Sunt officia eum qui molestiae. Nesciunt quidem cu...", unit_price: 32301)
        @customer1 = Customer.create!(first_name: "Joey", last_name: "Ondricka")
        @invoice1 = Invoice.create!(customer_id: @customer1.id, status: "cancelled")
        @invoice_item1 = InvoiceItem.create!(item_id: @item1.id, invoice_id: @invoice1.id, quantity: 1, unit_price: 75100, status: "shipped",)
        @invoice_item2 = InvoiceItem.create!(item_id: @item2.id, invoice_id: @invoice1.id, quantity: 3, unit_price: 200000, status: "packaged",)

        expect(@invoice1.total_revenue).to eq(6751.00)
      end

      it '.discount_amount' do
        merchant1 = Merchant.create!(name: "Joyce's Things")
        merchant2 = Merchant.create!(name: "Samwise's Things")

        item1 = merchant1.items.create!(name: "Bowtie", description: "it looks cool", unit_price: 1200)
        item2 = merchant1.items.create!(name: "Earrings", description: "it looks cool", unit_price: 2000)

        item3 = merchant2.items.create!(name: "Stuffed elephant", description: "fun for kids", unit_price: 1550)

        customer = Customer.create!(first_name: "Jamie", last_name: "Personname")

        invoice = customer.invoices.create(status: "in progress")

        invoice_item1 = InvoiceItem.create!(item: item1, invoice: invoice, quantity: 10, unit_price: 1300, status: "packaged")
        invoice_item2 = InvoiceItem.create!(item: item2, invoice: invoice, quantity: 5, unit_price: 2000, status: "shipped")
        invoice_item3 = InvoiceItem.create!(item: item3, invoice: invoice, quantity: 7, unit_price: 1550, status: "pending")

        discount = merchant1.discounts.create!(quantity: 5, percent_discount: 10)
        discount = merchant1.discounts.create!(quantity: 10, percent_discount: 7)
        discount2 = merchant2.discounts.create!(quantity: 10, percent_discount: 15)

        expect(invoice.discount_amount).to eq(23.0)
        expect(invoice.discount_amount).not_to eq(19.1)
      end

      it '.revenue_after_discount' do
        merchant1 = Merchant.create!(name: "Joyce's Things")
        merchant2 = Merchant.create!(name: "Samwise's Things")

        item1 = merchant1.items.create!(name: "Bowtie", description: "it looks cool", unit_price: 1200)
        item2 = merchant1.items.create!(name: "Earrings", description: "it looks cool", unit_price: 2000)

        item3 = merchant2.items.create!(name: "Stuffed elephant", description: "fun for kids", unit_price: 1550)

        customer = Customer.create!(first_name: "Jamie", last_name: "Personname")

        invoice = customer.invoices.create(status: "in progress")

        invoice_item1 = InvoiceItem.create!(item: item1, invoice: invoice, quantity: 10, unit_price: 1300, status: "packaged")
        invoice_item2 = InvoiceItem.create!(item: item2, invoice: invoice, quantity: 5, unit_price: 2000, status: "shipped")
        invoice_item3 = InvoiceItem.create!(item: item3, invoice: invoice, quantity: 7, unit_price: 1550, status: "pending")

        discount = merchant1.discounts.create!(quantity: 5, percent_discount: 10)
        discount = merchant1.discounts.create!(quantity: 10, percent_discount: 7)
        discount2 = merchant2.discounts.create!(quantity: 10, percent_discount: 15)
        
        expect(invoice.revenue_after_discount).to eq(315.5)
      end

    end


  describe "class methods" do
    describe '#not_completed' do
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
end
