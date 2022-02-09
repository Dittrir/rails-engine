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
end
