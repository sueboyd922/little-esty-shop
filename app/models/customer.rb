class Customer < ApplicationRecord
  has_many :invoices
  has_many :invoice_items, through: :invoices
  has_many :transactions, through: :invoices
  validates_presence_of :first_name, :last_name

 def self.top_5_customers
   customers = joins(:transactions).where(result: 0)
   wip = customers.joins(invoices: :invoice_items).distinct.select("customers.*, sum(invoice_items.quantity * invoice_items.unit_price) as total_revenue_generated").group("customers.id")
   # wip = joins(:transactions, invoices: :invoice_items).where(transactions: {result: 0}).distinct.select("customers.*, sum(invoice_items.quantity * invoice_items.unit_price) as total_revenue_generated").group("customers.id")
   require "pry"; binding.pry
 end
end
