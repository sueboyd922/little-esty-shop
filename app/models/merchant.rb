class Merchant < ApplicationRecord
  has_many :items
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  has_many :customers, through: :invoices
  has_many :transactions, through: :invoices
  
  validates_presence_of(:name)

  def self.top_5_merchants
     merchants_with_valid_invoices = self.joins(invoices: :transactions)
                                           .where('transactions.result = 0')
                                           .select('merchants.*').distinct
    merchants_with_valid_invoices.joins(:invoice_items)
                                 .select('merchants.*, sum(invoice_items.quantity * invoice_items.unit_price) as total_revenue')
                                 .group(:id)
                                 .order(total_revenue: :desc)
                                 .limit(5)
  end

  def items_ready_to_ship
    InvoiceItem.where(item: items).where.not(status: 2)
  end

  def enabled_items
    items.where(status: 0)
  end

  def disabled_items
    items.where(status: 1)
  end

  def top_5_customers
     customers.joins(:transactions)
             .where('transactions.result = 0 AND invoices.status = 2')
             .select("customers.*, count(transactions.*) as transaction_count")
             .group(:id)
             .order(transaction_count: :desc)
             .limit(5)
  end
end
