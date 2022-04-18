class Admin::MerchantsController < ApplicationController

  def index
    @merchants = Merchant.all
    binding.pry
  end

end
