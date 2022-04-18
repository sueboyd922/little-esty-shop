class Admin::MerchantsController < ApplicationController

  def index
    @merchants = Merchant.all
  end

  def update
    @merchant = Merchant.find(params[:id])
    # binding.pry
    if !params[:status].nil?
      @merchant.update(status: params[:status])
      redirect_to action: :index
    end
  end

end
