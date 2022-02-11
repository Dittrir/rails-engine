class Api::V1::SearchController < ApplicationController

  def find_item
    if self.good_params? == true
      if params[:min_price].present? && params[:max_price].present?
        self.find_by_min_and_max_price
      elsif params[:name].present?
        self.find_by_name
      elsif params[:min_price].present?
        self.find_by_min_price
      elsif params[:max_price].present?
        self.find_by_max_price
      else
        render_query_param_message
      end
    end
  end

  def find_by_name
    item = Item.where("lower(name) LIKE ?", "%#{params[:name].downcase}%")
               .order(:name)
               .first
    result_processor(item)
  end

  def find_by_min_price
    if self.below_zero? == false
      item = Item.where("unit_price >= ?", params[:min_price])
                 .order(:name)
                 .first
      result_processor(item)
    end
  end

  def find_by_max_price
    if self.below_zero? == false
      item = Item.where("unit_price <= ?", params[:max_price])
                 .order(unit_price: :desc)
                 .first
      result_processor(item)
    end
  end

  def find_by_min_and_max_price
    if params[:min_price].to_f < params[:max_price].to_f && params[:min_price].to_f > 0
      item = Item.where("unit_price <= ?", params[:max_price])
                 .where("unit_price >= ?", params[:min_price])
                 .order(unit_price: :desc)
                 .first
      result_processor(item)
    else
      render(json: {data: {message: "Min price can't be more than max price"}}, status: 400 )
    end
  end

  def find_all_items
    if params[:name].present?
      item = Item.where("lower(name) LIKE ?", "%#{params[:name].downcase}%")
                 .order(:name)
      multiple_results_processor(item)
    else
      render_query_param_message
    end
  end

  def find_merchant
    if params[:name].present?
      merchant = Merchant.where("lower(name) LIKE ?", "%#{params[:name].downcase}%")
                         .order(:name)
                         .first
      result_processor(merchant)
    else
      render_query_param_message
    end
  end

  def find_all_merchants
    if params[:name].present?
      merchant = Merchant.where("lower(name) LIKE ?", "%#{params[:name].downcase}%")
                         .order(:name)
      if merchant == []
        render(json: {data: []}, status: 200 )
      else
        render(json: MerchantSerializer.new(merchant), status: 200)
      end
    else
      render_query_param_message
    end
  end

  def result_processor(variable)
    if variable == nil
      render(json: {data: {message: "There were no matches"}}, status: 200 )
    elsif variable.class == Item
      render(json: ItemSerializer.new(variable), status: 200)
    else
      render(json: MerchantSerializer.new(variable), status: 200)
    end
  end

  def multiple_results_processor(variable)
    if variable == []
      render(json: {data: []}, status: 200 )
    elsif
      render(json: ItemSerializer.new(variable), status: 200)
    else
      render(json: MerchantSerializer.new(variable), status: 200)
    end
  end

  def below_zero?
    if params[:max_price].to_f < 0 || params[:min_price].to_f < 0
      render(json: {error: "Error Message: Price parameters can't be less than 0"}, status: 400 )
    else return false
    end
  end

  def good_params?
    if params[:min_price].present? && params[:name].present?
      render_query_param_message
    elsif params[:max_price].present? && params[:name].present?
      render_query_param_message
    else return true
    end
  end

  def render_query_param_message
    render(json: {data: {message: "Insufficent query parameters"}}, status: 400 )
  end
end
