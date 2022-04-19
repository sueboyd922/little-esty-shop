class Admin::MerchantsController < ApplicationController

  def index
    @merchants = Merchant.all
  end

  def show
    @merchant = Merchant.find(params[:id])
  end

  def edit
    @merchant = Merchant.find(params[:id])
  end

  def update
    merchant = Merchant.find(params[:id])
     if !params[:status].nil?
      merchant.update(status: params[:status])
      redirect_to action: :index
     else
       merchant.update(merchant_params)
      redirect_to "/admin/merchants/#{merchant.id}"
      flash[:alert] = "Merchant info successfully updated!"
    end
  end

private
  def merchant_params
    params.permit(:name, :status)

  end

end
