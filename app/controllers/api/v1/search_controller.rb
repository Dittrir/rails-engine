class Api::V1::SearchController < ApplicationController
  def find_item
    if params[:name].present?
      item = Item.where("lower(name) LIKE ?", "%#{params[:name].downcase}%")
                 .order(:name)
                 .first
      render(json: ItemSerializer.new(item), status: 200)
    elsif params[:min_price].present?
    elsif params[:max_price].present?
    elsif params[:min_price].present? && params[:max_price].present?
    else
      render(json: {data: {message: "No Matches"}, status: 200})
    end
  end

  def find_all_items
  end

  def find_merchant
    if params[:name].present?
      merchant = Merchant.where("lower(name) LIKE ?", "%#{params[:name].downcase}%")
                 .order(:name)
                 .first
      render(json: MerchantSerializer.new(merchant), status: 200)
    else
      render(json: {data: {message: "Name cannot be missing"}, status: 200})
    end
  end

  def find_all_merchants
  end
end
