class Api::V1::SearchController < ApplicationController
  def find_item
    if params[:name].present?
      item = Item.where("lower(name) LIKE ?", "%#{params[:name].downcase}%")
                 .order(:name)
                 .first
      if item == nil
        render(json: {data: {message: "There were no matches"}}, status: 200 )
      else
        render(json: ItemSerializer.new(item), status: 200)
      end
    elsif params[:min_price].present?
      if params[:min_price].to_f < 0
        render(json: {data: {message: "Price parameters can't be less than 0"}}, status: 400 )
      else
      item = Item.where("unit_price > ?", params[:min_price])
                 .order(:name)
                 .first
        if item == nil
          render(json: {data: {message: "There were no matches"}}, status: 200 )
        else
          render(json: ItemSerializer.new(item), status: 200)
        end
      end
    elsif params[:max_price].present? && params[:max_price].to_f > 0
      item = Item.where("unit_price < ?", params[:max_price])
                 .order(unit_price: :desc)
                 .first
      if item == nil
        render(json: {data: {message: "There were no matches"}}, status: 200 )
      else
        render(json: ItemSerializer.new(item), status: 200)
      end
    elsif params[:min_price].present? && params[:max_price].present?
    else
      render(json: {data: {message: "Insufficent query parameters"}}, status: 400 )
    end
  end

  def find_all_items
    if params[:name].present?
      item = Item.where("lower(name) LIKE ?", "%#{params[:name].downcase}%")
                         .order(:name)
      if item == nil
        render(json: {data: {message: "There were no matches"}}, status: 200 )
      else
        render(json: ItemSerializer.new(item), status: 200)
      end
    else
      render(json: {data: {message: "Insufficent query parameters"}}, status: 400 )
    end
  end

  def find_merchant
    if params[:name].present?
      merchant = Merchant.where("lower(name) LIKE ?", "%#{params[:name].downcase}%")
                 .order(:name)
                 .first
      if merchant == nil
        render(json: {data: {message: "There were no matches"}}, status: 200 )
      else
        render(json: MerchantSerializer.new(merchant), status: 200)
      end
    else
      render(json: {data: {message: "Insufficent query parameters"}}, status: 400 )
    end
  end

  def find_all_merchants
    if params[:name].present?
      merchant = Merchant.where("lower(name) LIKE ?", "%#{params[:name].downcase}%")
                         .order(:name)
      if merchant == nil
        render(json: {data: {message: "No results were found"}}, status: 400 )
      else
        render(json: MerchantSerializer.new(merchant), status: 200)
      end
    else
      render(json: {data: {message: "Insufficent query parameters"}}, status: 400)
    end
  end
end
