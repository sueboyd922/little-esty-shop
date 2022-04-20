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

<<<<<<< HEAD
  def new
  end

  def create
    Merchant.create(name: params[:name], status: 1)
    redirect_to action: :index
=======
private
  def merchant_params
    params.permit(:name, :status)

>>>>>>> 6bc339af08700325a889838409589bbeece6db12
  end

end
