class InvoiceItem < ApplicationRecord
  belongs_to :invoice
  belongs_to :item
  has_one :merchant, through: :item
  has_many :discounts, through: :merchant


  validates_presence_of :quantity, :unit_price, :status
  validates :quantity, numericality: true
  validates :quantity, numericality: {only_integer: true, greater_than: 0}
  validates :unit_price, numericality: true
  validates :unit_price, numericality: {only_integer: true, greater_than: 0}

  enum status: {"packaged" => 0, "pending" => 1, "shipped" => 2}

  def has_discount?
    !applied_discount.nil?
  end

  def applied_discount
    discounts.where("quantity <= ?", self.quantity)
              .order(percent_discount: :desc)
              .limit(1).first
  end
end
