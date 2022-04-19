class Customer < ApplicationRecord
  has_many :invoices
  has_many :transactions, through: :invoices
  validates_presence_of :first_name, :last_name

  enum status: {"enabled" => 0, "disabled" => 1}

end
