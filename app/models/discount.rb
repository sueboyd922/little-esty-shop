class Discount < ApplicationRecord
  validates_presence_of :quantity, :percent_discount

  belongs_to :merchant
end
