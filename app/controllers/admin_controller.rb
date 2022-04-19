class AdminController < ApplicationController
  def show
    @top_5_customers = Customer.top_5_customers
    @invoices = Invoice.all
  end
end
