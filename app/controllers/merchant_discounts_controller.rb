class MerchantDiscountsController < ApplicationController

  def index
    @merchant = Merchant.find(params[:merchant_id])
    @facade = HolidayFacade.new
  end

  def show
    @discount = Discount.find(params[:id])
  end

  def new
    @discount = Discount.new(merchant_id: params[:merchant_id])
  end

  def create
    merchant = Merchant.find(params[:merchant_id])
    @discount = merchant.discounts.new(discount_params)
    if @discount.save
      redirect_to "/merchants/#{merchant.id}/discounts"
    else
      flash[:alert] = "Error: #{error_message(@discount.errors)}"
      render :new
    end
  end

  def edit
    @discount = Discount.find(params[:id])
  end

  def update
    discount = Discount.find(params[:id])
    discount.update(discount_params)
    redirect_to "/merchants/#{params[:merchant_id]}/discounts/#{discount.id}"
  end

  def destroy
    discount = Discount.find(params[:id])
    discount.destroy
    redirect_to "/merchants/#{discount.merchant.id}/discounts"
  end

  private
    def discount_params
      params.permit(:percent_discount, :quantity)
    end
end
