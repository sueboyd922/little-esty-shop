class ItemsController < ApplicationController
  # before_action :do_merchant, except: [:update, :destroy]

  def index
    @merchant = Merchant.find(params[:id])
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @item = Item.find(params[:id])
  end

  def edit
    @merchant = Merchant.find(params[:merchant_id])
    @item = Item.find(params[:id])
  end

  def update
    merchant = Merchant.find(params[:merchant_id])
    item = Item.find(params[:id])
    item.update(item_params)
    redirect_to "/merchants/#{merchant.id}/items/#{item.id}", notice: "Item Successfully Updated"
  end

  def new
    @merchant = Merchant.find(params[:id])
    @items = @merchant.items
  end

  def create
    merchant = Merchant.find(params[:merchant_id])
    item = merchant.items.create!(item_params)
    redirect_to "/merchants/#{merchant.id}/items"
  end

  private

  def item_params
    params.permit(:name, :description, :unit_price)
  end
end
