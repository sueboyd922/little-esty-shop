require 'rails_helper'

RSpec.describe Discount, type: :model do
  describe 'validations' do
    it { should validate_presence_of :quantity }
    it { should validate_numericality_of(:quantity) }
    it { should allow_value(10).for(:quantity) }
    it { should_not allow_value(0).for(:quantity) }
    it { should validate_presence_of :percent_discount }
    it { should validate_numericality_of(:percent_discount) }
    it { should allow_value(4).for(:percent_discount) }
    it { should_not allow_value(0).for(:percent_discount) }
    it { should_not allow_value(104).for(:percent_discount) }
  end

  describe 'relationships' do
    it { should belong_to :merchant }

  end
end
