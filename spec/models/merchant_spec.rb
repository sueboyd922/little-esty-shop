require "rails_helper"

RSpec.describe Merchant, type: :model do
  describe "relationships" do
    it { should have_many :items }
    it { should have_many :discounts }
    it { should have_many(:invoice_items).through(:items) }
    it { should have_many(:invoices).through(:invoice_items) }
    it { should have_many(:customers).through(:invoices) }
    it { should have_many(:transactions).through(:invoices) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should define_enum_for(:status).with([:enabled, :disabled]) }
  end

  describe "instance methods" do
    describe ".items_ready_to_ship" do
      it "returns invoice_items of a merchant with status other than shipped" do
        @merchant1 = Merchant.create!(name: "Schroeder-Jerde")
        @item1 = @merchant1.items.create!(name: "Item Qui Esse", description: "Nihil autem sit odio inventore deleniti. Est lauda...", unit_price: 75107)
        @item2 = @merchant1.items.create!(name: "Item Autem Minima", description: "Cumque consequuntur ad. Fuga tenetur illo molestia...", unit_price: 67076)
        @item3 = @merchant1.items.create!(name: "Item Ea Voluptatum", description: "Sunt officia eum qui molestiae. Nesciunt quidem cu...", unit_price: 32301)
        @customer1 = Customer.create!(first_name: "Joey", last_name: "Ondricka")
        @invoice1 = Invoice.create!(customer_id: @customer1.id, status: "cancelled")
        @invoice2 = Invoice.create!(customer_id: @customer1.id, status: "in progress")
        @invoice_item1 = InvoiceItem.create!(item_id: @item1.id, invoice_id: @invoice1.id, quantity: 1, unit_price: 75100, status: "shipped")
        @invoice_item2 = InvoiceItem.create!(item_id: @item2.id, invoice_id: @invoice2.id, quantity: 3, unit_price: 200000, status: "packaged")
        @invoice_item3 = InvoiceItem.create!(item_id: @item3.id, invoice_id: @invoice2.id, quantity: 1, unit_price: 32301, status: "pending")

        expect(@merchant1.items_ready_to_ship).to eq([@invoice_item2, @invoice_item3])
      end
    end

    describe "enabled/disabled items" do
      before(:each) do
        @merchant1 = Merchant.create!(name: "Klein, Rempel and Jones")
        @merchant2 = Merchant.create!(name: "Williamson Group")

        @item1 = @merchant1.items.create!(name: "Item Ea Voluptatum", description: "A thing that does things", unit_price: 7654)
        @item2 = @merchant1.items.create!(name: "Item Quo Magnam", description: "A thing that does nothing", unit_price: 10099)
        @item3 = @merchant1.items.create!(name: "Item Voluptatem Sint", description: "A thing that does everything", unit_price: 8790, status: "disabled")
        @item4 = @merchant2.items.create!(name: "Item Rerum Est", description: "A thing that barks", unit_price: 3455)
        @item5 = @merchant2.items.create!(name: "Item Itaque Consequatur", description: "A thing that makes noise", unit_price: 7900)
      end

      it "#enabled_items" do
        expect(@merchant1.enabled_items).to eq([@item1, @item2])
        expect(@merchant2.enabled_items).to eq([@item4, @item5])
      end

      it "#disabled_items" do
        expect(@merchant1.disabled_items).to eq([@item3])
        expect(@merchant2.disabled_items).to eq([])
      end
    end

    describe ".top_5_customers" do
      it "returns top-5 customers with most successful transactions" do
        merchant1 = Merchant.create!(name: "Klein, Rempel and Jones")
        item1 = FactoryBot.create_list(:item, 1, merchant_id: merchant1.id)[0]
        FactoryBot.create_list(:customer, 7)
        cust1 = Customer.all[0]
        cust2 = Customer.all[1]
        cust3 = Customer.all[2]
        cust4 = Customer.all[3]
        cust5 = Customer.all[4]
        cust6 = Customer.all[5]
        cust7 = Customer.all[6]

        invoice1 = FactoryBot.create_list(:invoice, 1, customer_id: cust5.id, status: 2)[0]
        invoice2 = FactoryBot.create_list(:invoice, 1, customer_id: cust3.id, status: 2)[0]
        invoice3 = FactoryBot.create_list(:invoice, 1, customer_id: cust1.id, status: 2)[0]
        invoice4 = FactoryBot.create_list(:invoice, 1, customer_id: cust6.id, status: 2)[0]
        invoice5 = FactoryBot.create_list(:invoice, 1, customer_id: cust7.id, status: 0)[0]
        invoice6 = FactoryBot.create_list(:invoice, 1, customer_id: cust2.id, status: 2)[0]
        invoice7 = FactoryBot.create_list(:invoice, 1, customer_id: cust4.id, status: 2)[0]

        FactoryBot.create_list(:invoice_item, 1, item_id: item1.id, invoice_id: invoice1.id)
        FactoryBot.create_list(:invoice_item, 1, item_id: item1.id, invoice_id: invoice2.id)
        FactoryBot.create_list(:invoice_item, 1, item_id: item1.id, invoice_id: invoice3.id)
        FactoryBot.create_list(:invoice_item, 1, item_id: item1.id, invoice_id: invoice4.id)
        FactoryBot.create_list(:invoice_item, 1, item_id: item1.id, invoice_id: invoice5.id)
        FactoryBot.create_list(:invoice_item, 1, item_id: item1.id, invoice_id: invoice6.id)
        FactoryBot.create_list(:invoice_item, 1, item_id: item1.id, invoice_id: invoice7.id)

        FactoryBot.create_list(:transaction, 10, invoice_id: invoice1.id, result: 0)
        FactoryBot.create_list(:transaction, 8, invoice_id: invoice2.id, result: 0)
        FactoryBot.create_list(:transaction, 7, invoice_id: invoice3.id, result: 0)
        FactoryBot.create_list(:transaction, 6, invoice_id: invoice4.id, result: 0)
        FactoryBot.create_list(:transaction, 4, invoice_id: invoice5.id, result: 0)
        FactoryBot.create_list(:transaction, 2, invoice_id: invoice6.id, result: 0)
        FactoryBot.create_list(:transaction, 1, invoice_id: invoice7.id, result: 0)
        top_cust_names = merchant1.top_5_customers.map {|cust| cust.first_name}
        # require "pry"; binding.pry
        expect(top_cust_names).to eq([cust5.first_name, cust3.first_name, cust1.first_name, cust6.first_name, cust7.first_name])
      end
    end

    describe "class methods" do
      describe "#top_5_merchants" do
        it "returns the top five merchanst with largest total revenue" do
          merchant1 = FactoryBot.create_list(:merchant, 1, name: "merchant1")[0]
          merchant2 = FactoryBot.create_list(:merchant, 1, name: "merchant2")[0]
          merchant3 = FactoryBot.create_list(:merchant, 1, name: "merchant3")[0]
          merchant4 = FactoryBot.create_list(:merchant, 1, name: "merchant4")[0]
          merchant5 = FactoryBot.create_list(:merchant, 1, name: "merchant5")[0]
          merchant6 = FactoryBot.create_list(:merchant, 1, name: "merchant6")[0]

          item1 = FactoryBot.create_list(:item, 1, merchant: merchant1)[0]
          item2 = FactoryBot.create_list(:item, 1, merchant: merchant2)[0]
          item3 = FactoryBot.create_list(:item, 1, merchant: merchant3)[0]
          item4 = FactoryBot.create_list(:item, 1, merchant: merchant4)[0]
          item5 = FactoryBot.create_list(:item, 1, merchant: merchant5)[0]
          item6 = FactoryBot.create_list(:item, 1, merchant: merchant6)[0]

          invoice1 = FactoryBot.create_list(:invoice, 1)[0]
          invoice2 = FactoryBot.create_list(:invoice, 1)[0]
          invoice3 = FactoryBot.create_list(:invoice, 1)[0]
          invoice4 = FactoryBot.create_list(:invoice, 1)[0]
          invoice5 = FactoryBot.create_list(:invoice, 1)[0]
          invoice6 = FactoryBot.create_list(:invoice, 1)[0]

          invoice_item1 = FactoryBot.create_list(:invoice_item, 1, invoice: invoice1, item: item1, quantity: 10, unit_price: 10)[0]
          invoice_item2 = FactoryBot.create_list(:invoice_item, 1, invoice: invoice2, item: item2, quantity: 9, unit_price: 10)[0]
          invoice_item3 = FactoryBot.create_list(:invoice_item, 1, invoice: invoice3, item: item3, quantity: 8, unit_price: 10)[0]
          invoice_item4 = FactoryBot.create_list(:invoice_item, 1, invoice: invoice4, item: item4, quantity: 7, unit_price: 10)[0]
          invoice_item5 = FactoryBot.create_list(:invoice_item, 1, invoice: invoice5, item: item5, quantity: 5, unit_price: 10)[0]
          invoice_item6 = FactoryBot.create_list(:invoice_item, 1, invoice: invoice6, item: item6, quantity: 9, unit_price: 10)[0]

          transaction1_0 = FactoryBot.create_list(:transaction, 1, invoice: invoice1, result: 0)
          transaction1_1 = FactoryBot.create_list(:transaction, 1, invoice: invoice1, result: 1)
          transaction2_1 = FactoryBot.create_list(:transaction, 1, invoice: invoice2, result: 1)
          transaction3_0 = FactoryBot.create_list(:transaction, 1, invoice: invoice3, result: 0)
          transaction4_0 = FactoryBot.create_list(:transaction, 1, invoice: invoice4, result: 0)
          transaction5_1 = FactoryBot.create_list(:transaction, 1, invoice: invoice5, result: 1)
          transaction5_0 = FactoryBot.create_list(:transaction, 1, invoice: invoice5, result: 0)
          transaction6_0 = FactoryBot.create_list(:transaction, 1, invoice: invoice6, result: 0)

          expect(Merchant.top_5_merchants).to eq([merchant1, merchant6, merchant3, merchant4, merchant5])
        end
      end


      describe "#enabled_merchants, #disabled_merchants" do
        it "lists enabled and disabled merchants" do
          merchant1 = FactoryBot.create_list(:merchant, 1, status: 0)[0]
          merchant2 = FactoryBot.create_list(:merchant, 1, status: 0)[0]
          merchant3 = FactoryBot.create_list(:merchant, 1, status: 0)[0]
          merchant4 = FactoryBot.create_list(:merchant, 1, status: 1)[0]
          merchant5 = FactoryBot.create_list(:merchant, 1, status: 1)[0]
          merchant6 = FactoryBot.create_list(:merchant, 1, status: 1)[0]

          expect(Merchant.enabled_merchants).to eq([merchant1, merchant2, merchant3])
          expect(Merchant.disabled_merchants).to eq([merchant4, merchant5, merchant6])
        end
      end


      describe "popular_items" do
        it "returns a list of items ordered by potential_revenue" do
          merchant_1 = Merchant.create!(name: "Stuff and Things ")
          item_1 = FactoryBot.create_list(:item, 1, merchant_id: merchant_1.id)[0]
          item_2 = FactoryBot.create_list(:item, 2, merchant_id: merchant_1.id)[1]
          item_3 = FactoryBot.create_list(:item, 3, merchant_id: merchant_1.id)[2]
          item_4 = FactoryBot.create_list(:item, 4, merchant_id: merchant_1.id)[3]
          item_5 = FactoryBot.create_list(:item, 5, merchant_id: merchant_1.id)[4]
          item_6 = FactoryBot.create_list(:item, 6, merchant_id: merchant_1.id)[5]
          item_7 = FactoryBot.create_list(:item, 7, merchant_id: merchant_1.id)[6]

          FactoryBot.create_list(:customer, 7)
          cust1 = Customer.all[0]
          cust2 = Customer.all[1]
          cust3 = Customer.all[2]
          cust4 = Customer.all[3]
          cust5 = Customer.all[4]
          cust6 = Customer.all[5]
          cust7 = Customer.all[6]

          invoice1 = FactoryBot.create_list(:invoice, 1, customer_id: cust1.id, status: 2)[0]
          invoice2 = FactoryBot.create_list(:invoice, 2, customer_id: cust2.id, status: 2)[1]
          invoice3 = FactoryBot.create_list(:invoice, 3, customer_id: cust3.id, status: 2)[2]
          invoice4 = FactoryBot.create_list(:invoice, 4, customer_id: cust4.id, status: 2)[3]
          invoice5 = FactoryBot.create_list(:invoice, 5, customer_id: cust5.id, status: 0)[4]
          invoice6 = FactoryBot.create_list(:invoice, 6, customer_id: cust6.id, status: 2)[5]
          invoice7 = FactoryBot.create_list(:invoice, 7, customer_id: cust7.id, status: 2)[6]

          FactoryBot.create_list(:invoice_item, 1, item_id: item_1.id, invoice_id: invoice1.id, quantity: 10, unit_price: 10)
          FactoryBot.create_list(:invoice_item, 2, item_id: item_2.id, invoice_id: invoice2.id, quantity: 10, unit_price: 25)
          FactoryBot.create_list(:invoice_item, 3, item_id: item_3.id, invoice_id: invoice3.id, quantity: 10, unit_price: 245)
          FactoryBot.create_list(:invoice_item, 4, item_id: item_4.id, invoice_id: invoice4.id, quantity: 10, unit_price: 321)
          FactoryBot.create_list(:invoice_item, 5, item_id: item_5.id, invoice_id: invoice5.id, quantity: 10, unit_price: 10)
          FactoryBot.create_list(:invoice_item, 6, item_id: item_6.id, invoice_id: invoice6.id, quantity: 10, unit_price: 369)
          FactoryBot.create_list(:invoice_item, 7, item_id: item_7.id, invoice_id: invoice7.id, quantity: 10, unit_price: 400)

          FactoryBot.create_list(:transaction, 1, invoice_id: invoice1.id, result: 1)
          FactoryBot.create_list(:transaction, 2, invoice_id: invoice2.id, result: 0)
          FactoryBot.create_list(:transaction, 3, invoice_id: invoice3.id, result: 0)
          FactoryBot.create_list(:transaction, 4, invoice_id: invoice4.id, result: 0)
          FactoryBot.create_list(:transaction, 5, invoice_id: invoice5.id, result: 1)
          FactoryBot.create_list(:transaction, 6, invoice_id: invoice6.id, result: 0)
          FactoryBot.create_list(:transaction, 7, invoice_id: invoice7.id, result: 0)

          expected = [item_7, item_6, item_4, item_3, item_2]

          expect(merchant_1.popular_items).to eq(expected)
        end
      end
    end
  end
end
