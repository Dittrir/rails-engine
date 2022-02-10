class Api::V1::MerchantItemsController < ApplicationController
  def index
    merchant = Merchant.find(params[:id])
    items = merchant.items
    if items == []
      render :status => 404
    else
      render(json: ItemSerializer.new(merchant.items))
    end
  end
end
