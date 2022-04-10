class Invoice < ApplicationRecord
  belongs_to :customer
  has_many :transactions
  has_many :invoice_items



  enum status: {"cancelled" => 0, "in progress" => 1, "completed" => 2}


end
