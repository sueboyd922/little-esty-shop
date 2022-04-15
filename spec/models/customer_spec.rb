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

  describe 'instance methods' do 
    describe '.successful_transactions_count' do 
      it 'returns the number of successful transactions' do 
          FactoryBot.create_list(:customer, 7) 
          cust1 = Customer.all[0]
          invoice1 = FactoryBot.create_list(:invoice, 1, customer_id: cust1.id, status: 2)[0]
          invoice2 = FactoryBot.create_list(:invoice, 1, customer_id: cust1.id, status: 0)[0]
          FactoryBot.create_list(:transaction, 10, invoice_id: invoice1.id, result: 0) 
          FactoryBot.create_list(:transaction, 2, invoice_id: invoice1.id, result: 1) 
          FactoryBot.create_list(:transaction, 2, invoice_id: invoice2.id, result: 0) 
          
          expect(cust1.successful_transactions_count).to eq(10)
      end
    end
  end
end
