class ItemsController < ApplicationController
  #
  # def index
  #   @merchant = Merchant.find(params[:merchant_id])
  # end

  # def update
  #   @merchant = Merchant.find(params[:merchant_id])
  #   if !params[:enable].nil?
  #     item = Item.find(params[:enable])
  #     item.update(status: 0)
  #     redirect_to "/merchants/#{@merchant.id}/items"
  #   elsif !params[:disable].nil?
  #     item = Item.find(params[:disable])
  #     item.update(status: 1)
  #     redirect_to "/merchants/#{@merchant.id}/items"
  #   else
  #     item = Item.find(params[:item_id])
  #     item.update(item_params)
  #     redirect_to "/merchants/#{@merchant.id}/items/#{item.id}", notice: "Item Successfully Updated"
  #   end
  # end

  # def show
  #   @merchant = Merchant.find(params[:merchant_id])
  #   @item = Item.find(params[:item_id])
  # end

  # def edit
  #   @merchant = Merchant.find(params[:merchant_id])
  #   @item = Item.find(params[:item_id])
  # end

  # def new
  #   @merchant = Merchant.find(params[:merchant_id])
  #   @items = @merchant.items
  # end

  # def create
  #   merchant = Merchant.find(params[:merchant_id])
  #   item = merchant.items.create!(item_params)
  #   redirect_to "/merchants/#{merchant.id}/items"
  # end

  private

  def item_params
    params.permit(:name, :description, :unit_price)
  end
end
