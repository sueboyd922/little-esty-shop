class Invoice < ApplicationRecord
  belongs_to :customer
  has_many :invoice_items, dependent: :destroy
  has_many :items, through: :invoice_items
  has_many :transactions, dependent: :destroy

  enum status: {"cancelled" => 0, "in progress" => 1, "completed" => 2}


  def self.not_completed
    where(invoices: {status: 1}).order(created_at: :asc)
  end

  def total_revenue
    invoice_items.sum("unit_price * quantity").to_f/100
  end

  def revenue_after_discount
    total_revenue - discount_amount
  end

  def discount_amount
    invoice_items.joins(:discounts)
    .select("invoice_items.*, max(invoice_items.quantity * (invoice_items.unit_price * (discounts.percent_discount / 100.0))) as discount_")
    .where("items.merchant_id = discounts.merchant_id")
    .where("invoice_items.quantity >= discounts.quantity")
    .group(:id)
    .sum(&:discount_).to_f / 100
  end
end
