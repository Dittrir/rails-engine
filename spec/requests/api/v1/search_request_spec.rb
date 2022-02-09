require 'rails_helper'

RSpec.describe 'The search API' do
  it 'find a single item which matches a search term' do
    merchant_1 = create(:merchant)
    merchant_2 = create(:merchant)
    target_item = create(:item, name: 'Paraglider', merchant_id: merchant_1.id)
    non_search_item_1 = create(:item, name: 'Ski Bindings', merchant_id: merchant_1.id)
    non_search_item_2 = create(:item, name: 'Art Supplies', merchant_id: merchant_2.id)
    non_search_item_3 = create(:item, name: 'Bazooka', merchant_id: merchant_2.id)

    get "/api/v1/items/find?name=paraglide"

    search_item = JSON.parse(response.body, symbolize_names: true)
    item_data = item[:data]

    expect(response).to be_successful
    expect(item_data.count).to eq(1)

    expect(item_data).to have_key(:id)
    expect(item_data[:id].to_i).to be_an(Integer)

    expect(item_data[:attributes]).to have_key(:name)
    expect(item_data[:attributes][:name]).to be_a(String)

    expect(item_data[:attributes]).to have_key(:description)
    expect(item_data[:attributes][:description]).to be_a(String)

    expect(item_data[:attributes]).to have_key(:unit_price)
    expect(item_data[:attributes][:unit_price]).to be_a(Float)
  end
end
