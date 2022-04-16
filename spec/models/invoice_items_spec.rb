require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do

  describe 'relationships' do
    it { should belong_to :invoice }
    it { should belong_to :item }
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
    describe '.sold_at' do 
      it 'formats the sold_at unit_price to bigdecimal in dollars' do 
        item = FactoryBot.create_list(:item, 1)[0]
        invoice = FactoryBot.create_list(:invoice, 1)[0]
        invoice_item = FactoryBot.create_list(:invoice_item, 1, invoice_id: invoice.id, item_id: item.id, unit_price: 1000)[0]

        expect(invoice_item.sold_at).to eq(10.00.to_d)
      end
    end
  end

end
