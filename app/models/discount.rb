class Discount < ApplicationRecord
  validates_presence_of :quantity, :percent_discount
  validates_numericality_of :percent_discount, :quantity
  validates :percent_discount, :inclusion => 1...99
  validates :quantity, numericality: { greater_than: 0 }

  belongs_to :merchant
end
