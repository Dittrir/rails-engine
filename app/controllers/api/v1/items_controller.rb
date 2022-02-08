class Api::V1::ItemsController < ApplicationController
  def index
    render(json: ItemSerializer.new(Item.all))
  end

  def show
    if Item.exists?(params[:id])
      render(json: ItemSerializer.new(Item.find(params[:id])))
    else
      render :status => 404
    end
  end

  def create
    item = Item.create(item_params)
    if item.save
      render(json: ItemSerializer.new(item), status: :created)
    else
    end
  end

  def update
    render(json: ItemSerializer.new(Item.update(params[:id], item_params)))
  end

  def destroy
    render json: Item.destroy(params[:id])
  end

private

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end
