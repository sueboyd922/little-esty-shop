class Admin::MerchantsController < ApplicationController

  # def index
  #   @invoices = Invoice.all
  # end

  # def show
  #   @invoice = Invoice.find(params[:id])
  # end

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
