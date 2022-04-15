class Customer < ApplicationRecord
  has_many :invoices
  has_many :transactions, through: :invoices 
  validates_presence_of :first_name, :last_name

  def successful_transactions_count
    Customer.joins(invoices: :transactions)
        .where("transactions.result = 0 AND invoices.status = 2 AND customers.id = #{self.id}")
        .count
  end
end
