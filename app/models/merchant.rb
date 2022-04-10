class Merchant < ApplicationRecord
  has_many :items
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  has_many :customers, through: :invoices #source: :invoice_items
  has_many :transactions, through: :invoices

  validates_presence_of(:name)

  def top_5_transactions #gets top 5 most successful transaction ids of the merchant and stores then in an array
    top = []
    trans = transactions.where('transactions.result = 0').group(:invoice_id).count.sort_by {|k, v| v}.last(5).flatten!
    trans.each_with_index do |v, i|
      if i.even?
        top << v
      end
    end
    top
  end

  def top_5_customers #uses the top 5 transaction ids to get their corresponding customer names
    customers.joins(invoices: :transactions).where('transactions.result = 0').group('customers.id') # select, order, limit
    #select all customers, count all the successful trans and give a var ('as' something for trans count), then order by descending on that var, then limit 5
    #.select('customers.*, count(transactions) as trans_count')  order by desc on trans_count and then limit 5 at the end

    # top_t = top_5_transactions
    # control = 0
    # customers = []
    binding.pry




    # top_t.each do |t|
    #   invoices.where("id = #{t}").each do |c|
    #     customers.where("id = #{c.customer_id}").each do |x|
    #       customers[control] = x.first_name + x.last_name
    #       control += 1
    #     end
    #   end
    # end
    # binding.pry
    #
    # return customers, top_t
  end

  # def all_invoices
  #   Invoice.joins(invoice_items: :items).where("items.merchant_id = #{id}")
  #   binding.pry
  # end

end
