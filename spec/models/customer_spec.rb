require "rails_helper"

RSpec.describe Customer, type: :model do

  describe 'associations' do
	  it {should have_many :invoices}
    it { should have_many(:transactions).through(:invoices)}
  end

  describe 'validations' do
    it { should validate_presence_of(:first_name)}
    it { should validate_presence_of(:last_name)}
  end

  describe 'class methods' do
    it '.top_5_customers' do
      FactoryBot.create_list(:customer, 7)
      customer_1 = Customer.all[0]
      customer_2 = Customer.all[1]
      customer_3 = Customer.all[2]
      customer_4 = Customer.all[3]
      customer_5 = Customer.all[4]
      customer_6 = Customer.all[5]
      customer_7 = Customer.all[6]

      Customer.all.each do |customer|
        FactoryBot.create_list(:invoice, 9, customer: customer)
      end

      Customer.all.each do |customer|
        [1,2,3,4,5,6].sample.times do
          number = [1,2,3,4].sample
          FactoryBot.create_list(:transaction, number, invoice: customer.invoices.sample, result: 1)
        end
      end

      #customer_1 4 successful
      FactoryBot.create_list(:transaction, 1, invoice: customer_1.invoices[0], result: 0)
      FactoryBot.create_list(:transaction, 1, invoice: customer_1.invoices[2], result: 0)
      FactoryBot.create_list(:transaction, 1, invoice: customer_1.invoices[4], result: 0)
      FactoryBot.create_list(:transaction, 1, invoice: customer_1.invoices[6], result: 0)
      #customer_2 7 successful
      FactoryBot.create_list(:transaction, 1, invoice: customer_2.invoices[0], result: 0)
      FactoryBot.create_list(:transaction, 1, invoice: customer_2.invoices[1], result: 0)
      FactoryBot.create_list(:transaction, 1, invoice: customer_2.invoices[2], result: 0)
      FactoryBot.create_list(:transaction, 1, invoice: customer_2.invoices[3], result: 0)
      FactoryBot.create_list(:transaction, 1, invoice: customer_2.invoices[4], result: 0)
      FactoryBot.create_list(:transaction, 1, invoice: customer_2.invoices[5], result: 0)
      FactoryBot.create_list(:transaction, 1, invoice: customer_2.invoices[6], result: 0)
      #customer_3 1 successful
      FactoryBot.create_list(:transaction, 1, invoice: customer_3.invoices[6], result: 0)
      #customer_4 5 successful
      FactoryBot.create_list(:transaction, 1, invoice: customer_4.invoices[0], result: 0)
      FactoryBot.create_list(:transaction, 1, invoice: customer_4.invoices[2], result: 0)
      FactoryBot.create_list(:transaction, 1, invoice: customer_4.invoices[3], result: 0)
      FactoryBot.create_list(:transaction, 1, invoice: customer_4.invoices[4], result: 0)
      FactoryBot.create_list(:transaction, 1, invoice: customer_4.invoices[5], result: 0)
      #customer_5 9 successful
      customer_5.invoices.each do |invoice|
        FactoryBot.create_list(:transaction, 1, invoice: invoice, result: 0)
      end
      #customer_6 0 successful
      #customer_7 6 successful
      FactoryBot.create_list(:transaction, 1, invoice: customer_7.invoices[2], result: 0)
      FactoryBot.create_list(:transaction, 1, invoice: customer_7.invoices[4], result: 0)
      FactoryBot.create_list(:transaction, 1, invoice: customer_7.invoices[5], result: 0)
      FactoryBot.create_list(:transaction, 1, invoice: customer_7.invoices[6], result: 0)
      FactoryBot.create_list(:transaction, 1, invoice: customer_7.invoices[7], result: 0)
      FactoryBot.create_list(:transaction, 1, invoice: customer_7.invoices[8], result: 0)

      expect(Customer.top_5_customers).to eq([customer_5, customer_2, customer_7, customer_4, customer_1])
    end
  end


end
