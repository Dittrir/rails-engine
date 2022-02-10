require 'rails_helper'

RSpec.describe 'The search API' do
  it 'find one merchant by name fragment' do
    merchant_1 = create(:merchant)
    target_merchant = create(:merchant, name: 'Target')
    merchant_2 = create(:merchant)
    merchant_3 = create(:merchant)

    get "/api/v1/merchants/find?name=target"

    search_merchant = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(search_merchant.count).to eq(1)

    merchant_data = search_merchant[:data]

    expect(merchant_data).to have_key(:id)
    expect(merchant_data[:id].to_i).to be_an(Integer)

    expect(merchant_data[:attributes]).to have_key(:name)
    expect(merchant_data[:attributes][:name]).to eq("#{target_merchant.name}")
  end

  it 'sad path: no name given for finding merchant' do
    merchant_1 = create(:merchant)
    target_merchant = create(:merchant, name: 'Target')
    merchant_2 = create(:merchant)
    merchant_3 = create(:merchant)

    get "/api/v1/merchants/find?name="

    return_value = JSON.parse(response.body, symbolize_names: true)

    expect(response).to_not be_successful
    expect(response.status).to eq(400)
    expect(return_value[:data][:message]).to eq("Insufficent query parameters")
  end

  it 'edge case: no params given' do
    merchant_1 = create(:merchant)
    target_merchant = create(:merchant, name: 'Target')
    merchant_2 = create(:merchant)
    merchant_3 = create(:merchant)

    get "/api/v1/merchants/find"

    search_merchant = JSON.parse(response.body, symbolize_names: true)

    expect(response).to_not be_successful
    expect(response.status).to eq(400)
  end

  it 'find all merchants by name fragment' do
    target_merchant_1 = create(:merchant, name: 'Target1')
    target_merchant_2 = create(:merchant, name: 'Target2')
    target_merchant_3 = create(:merchant, name: 'Target3')
    other_merchants = create_list(:merchant, 10)

    get "/api/v1/merchants/find_all?name=target"

    search_merchant = JSON.parse(response.body, symbolize_names: true)
    merchants_data = search_merchant[:data]

    expect(response).to be_successful
    expect(merchants_data.count).to eq(3)

    merchants_data.each do |merchant|
      expect(merchant).to have_key(:id)
      expect(merchant[:id].to_i).to be_an(Integer)

      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to be_an(String)
    end
  end

  it 'sad path: no name given for find all merchants by name fragment' do
    merchants = create_list(:merchant, 10)

    get "/api/v1/merchants/find_all?name="

    expect(response).to_not be_successful
    expect(response.status).to eq(400)

    return_value = JSON.parse(response.body, symbolize_names: true)

    expect(response).to_not be_successful
    expect(response.status).to eq(400)
    expect(return_value[:data][:message]).to eq("Insufficent query parameters")
  end

  it 'find one item by name fragment' do
    merchant_1 = create(:merchant)
    merchant_2 = create(:merchant)
    target_item = create(:item, name: 'Paraglider', merchant_id: merchant_1.id)
    non_search_item_1 = create(:item, name: 'Ski Bindings', merchant_id: merchant_1.id)
    non_search_item_2 = create(:item, name: 'Art Supplies', merchant_id: merchant_2.id)
    non_search_item_3 = create(:item, name: 'Bazooka', merchant_id: merchant_2.id)

    get "/api/v1/items/find?name=paraglide"

    search_item = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(search_item.count).to eq(1)

    item_data = search_item[:data]

    expect(item_data).to have_key(:id)
    expect(item_data[:id].to_i).to be_an(Integer)

    expect(item_data[:attributes]).to have_key(:name)
    expect(item_data[:attributes][:name]).to eq("#{target_item.name}")

    expect(item_data[:attributes]).to have_key(:description)
    expect(item_data[:attributes][:description]).to eq("#{target_item.description}")

    expect(item_data[:attributes]).to have_key(:unit_price)
    expect(item_data[:attributes][:unit_price]).to eq(target_item.unit_price)
  end

  it 'edge case: no match found find one item by name fragment' do
    target_item_1 = create(:item, name: 'Target1')
    other_items = create_list(:item, 10)

    get "/api/v1/items/find?name=asffrwreds"

    return_value = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(response.status).to eq(200)
    expect(return_value[:data][:message]).to eq("There were no matches")
  end

  it 'find one item by min price' do
    merchant_1 = create(:merchant)
    merchant_2 = create(:merchant)
    target_item = create(:item, unit_price: 1234567, merchant_id: merchant_1.id)
    non_search_item_1 = create(:item, name: 'Ski Bindings', merchant_id: merchant_1.id)
    non_search_item_2 = create(:item, name: 'Art Supplies', merchant_id: merchant_2.id)
    non_search_item_3 = create(:item, name: 'Bazooka', merchant_id: merchant_2.id)

    get "/api/v1/items/find?min_price=1234566"

    search_item = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(search_item.count).to eq(1)

    item_data = search_item[:data]

    expect(item_data).to have_key(:id)
    expect(item_data[:id].to_i).to be_an(Integer)

    expect(item_data[:attributes]).to have_key(:name)
    expect(item_data[:attributes][:name]).to eq("#{target_item.name}")

    expect(item_data[:attributes]).to have_key(:description)
    expect(item_data[:attributes][:description]).to eq("#{target_item.description}")

    expect(item_data[:attributes]).to have_key(:unit_price)
    expect(item_data[:attributes][:unit_price]).to eq(target_item.unit_price)
  end

  it 'sad path: find one item by min price, price is less than 0' do
    merchant_1 = create(:merchant)
    other_items = create_list(:item, 10, merchant_id: merchant_1.id)

    get "/api/v1/items/find?min_price=-1"

    return_value = JSON.parse(response.body, symbolize_names: true)

    expect(response).to_not be_successful
    expect(response.status).to eq(400)
    expect(return_value[:data][:message]).to eq("Min Price can't be less than 0")
  end

  it 'find all items by name fragment' do
    target_item_1 = create(:item, name: 'Target1')
    target_item_2 = create(:item, name: 'Target2')
    target_item_3 = create(:item, name: 'Target3')
    other_items = create_list(:item, 10)

    get "/api/v1/items/find_all?name=target"

    search_item = JSON.parse(response.body, symbolize_names: true)
    items_data = search_item[:data]

    expect(response).to be_successful
    expect(items_data.count).to eq(3)

    items_data.each do |item|
      expect(item).to have_key(:id)
      expect(item[:id].to_i).to be_an(Integer)

      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes][:name]).to be_an(String)

      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes][:description]).to be_an(String)

      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes][:unit_price]).to be_an(Float)
    end
  end

  it 'edge case: no param given for find all items by name fragment' do
    items = create_list(:item, 10)

    get "/api/v1/items/find_all"

    return_value = JSON.parse(response.body, symbolize_names: true)

    expect(response).to_not be_successful
    expect(response.status).to eq(400)
    expect(return_value[:data][:message]).to eq("Insufficent query parameters")
  end
end
