class Admin::MerchantsController < ApplicationController

  def index
    @merchants = Merchant.all
  end


  def edit
    merchant = Merchant.find(params[:id])
  end

  def update
    merchant = Merchant.find(params[:id])
    merchant.update(merchant_params)
    redirect_to 

  end

private
  def merchant_params
    params.require(:merchant).permit(:name)
  end

end
