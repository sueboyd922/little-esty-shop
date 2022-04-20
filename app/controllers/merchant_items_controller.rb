class MerchantItemsController < ApplicationController

  def index
    @merchant = Merchant.find(params[:merchant_id])
  end

  def update
    @merchant = Merchant.find(params[:merchant_id])
    if !params[:enable].nil?
      item = Item.find(params[:enable])
      item.update(status: 0)
      redirect_to "/merchants/#{@merchant.id}/items"
    elsif !params[:disable].nil?
      item = Item.find(params[:disable])
      item.update(status: 1)
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

  private

  def item_params
    params.permit(:name, :description, :unit_price)
  end
end
