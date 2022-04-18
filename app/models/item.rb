class Item < ApplicationRecord
  has_many :invoice_items
  belongs_to	:merchant
  has_many :invoices, through: :invoice_items

  validates_presence_of :name, :description, :unit_price, :status
  validates :unit_price, numericality: {only_integer: true}
  validates :unit_price, numericality: {greater_than: 0}

  enum status: {"enabled" => 0, "disabled" => 1}

  def best_day
    invoices.joins(:invoice_items, :transactions)
      .where(transactions: {result: 0})
      .select("invoices.*, SUM( invoice_items.unit_price * invoice_items.quantity)  AS totalrevenue")
      .group("invoices.id")
      .order(totalrevenue: :desc)
      .first.created_at
  end
end
