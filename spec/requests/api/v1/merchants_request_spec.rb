require 'rails_helper'

RSpec.describe 'The merchant API' do
  it 'sends a list of merchants' do
    create_list(:merchant, 3)

    get '/api/v1/merchants'

    merchants = JSON.parse(response.body, symbolize_names: true)
    merchants_data = merchants[:data]

    expect(response).to be_successful
    expect(merchants_data.count).to eq(3)

    merchants_data.each do |merchant|
      expect(merchant[:attributes]).to have_key(:id)
      expect(merchant[:attributes][:id]).to be_an(Integer)

      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to be_a(String)
    end
  end

  it 'can get one merchant by their id' do
    id = create(:merchant).id

    get "/api/v1/merchants/#{id}"

    merchant = JSON.parse(response.body, symbolize_names: true)
    merchant_data = merchant[:data][:attributes]

    expect(response).to be_successful

    expect(merchant_data).to have_key(:id)
    expect(merchant_data[:id]).to eq(id)

    expect(merchant_data).to have_key(:name)
    expect(merchant_data[:name]).to be_a(String)
  end

  it 'get all items for a given merchant ID' do
    id = create(:merchant).id
    item_ids = create_list(:item, 3, merchant_id: id)

    get "/api/v1/merchants/#{id}/items"

    items = JSON.parse(response.body, symbolize_names: true)
    items_data = items[:data]

    expect(response).to be_successful

    items_data.each do |item|
      expect(item[:attributes]).to have_key(:id)
      expect(item[:attributes][:id]).to eq(item[:attributes][:id])

      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes][:name]).to be_a(String)

      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes][:description]).to be_a(String)

      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes][:unit_price]).to be_a(Float)
    end
  end
end
