class MerchantItemsController < ApplicationController

  def index
    @merchant = Merchant.find(params[:merchant_id])
  end

  def update
    @merchant = Merchant.find(params[:merchant_id])
    if params[:item]
      item = Item.find(params[:item])
      item.update(status: params[:status])
      redirect_to "/merchants/#{@merchant.id}/items"
    else
      item = Item.find(params[:item_id])
      item.update(item_params)
      redirect_to "/merchants/#{@merchant.id}/items/#{item.id}", notice: "Item Successfully Updated"
    end
  end

  def show
    @item = Item.find(params[:item_id])
  end

  def edit
    @item = Item.find(params[:item_id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create
    merchant = Merchant.find(params[:merchant_id])
    merchant.items.create!(item_params)
    redirect_to "/merchants/#{merchant.id}/items"
  end

  private

  def item_params
    params.permit(:name, :description, :unit_price)
  end
end
