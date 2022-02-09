require 'rails_helper'

RSpec.describe 'The search API' do
  it 'find a single item which matches a search term' do
    merchant_1 = create(:merchant)
    merchant_2 = create(:merchant)
    target_item = create(:item, name: 'Paraglider', merchant_id: merchant_1.id)
    non_search_item_1 = create(:item, name: 'Ski Bindings', merchant_id: merchant_1.id)
    non_search_item_2 = create(:item, name: 'Art Supplies', merchant_id: merchant_2.id)
    non_search_item_3 = create(:item, name: 'Bazooka', merchant_id: merchant_2.id)

    get "/api/vi/items/find?name=paraglide"

    search_item = JSON.parse(response.body, symbolize_names: true)
    item_data = item[:data]

    expect(response).to be_successful
    expect(items_data.count).to eq(1)
  end
end
