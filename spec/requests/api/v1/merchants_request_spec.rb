require 'rails_helper'

RSpec.describe 'The merchant API' do
  describe "returns all merchants" do
    it 'happy path' do
      create_list(:merchant, 3)

      get '/api/v1/merchants'

      merchants = JSON.parse(response.body, symbolize_names: true)
      merchants_data = merchants[:data]

      expect(response).to be_successful
      expect(merchants_data.count).to eq(3)

      merchants_data.each do |merchant|
        expect(merchant).to have_key(:id)
        expect(merchant[:id].to_i).to be_an(Integer)

        expect(merchant[:attributes]).to have_key(:name)
        expect(merchant[:attributes][:name]).to be_a(String)
      end
    end

    it 'sad path: return an array of data, even if zero resources are found' do
      get '/api/v1/merchants'

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful

      merchants_data = merchants[:data]

      expect(merchants_data).to be_an(Array)
      expect(merchants_data.count).to eq(0)
    end
  end


  describe "returns one merchant" do
    it 'happy path' do
      id = create(:merchant).id

      get "/api/v1/merchants/#{id}"

      merchant = JSON.parse(response.body, symbolize_names: true)
      merchant_data = merchant[:data]

      expect(response).to be_successful

      expect(merchant_data).to have_key(:id)
      expect(merchant_data[:id].to_i).to eq(id)

      expect(merchant_data[:attributes]).to have_key(:name)
      expect(merchant_data[:attributes][:name]).to be_a(String)
    end

    it 'sad path: bad merchant id returns 404' do
      non_merchant_id = 10000000000

      get "/api/v1/merchants/#{non_merchant_id}"

      expect(response).to_not be_successful
      expect(response.status).to eq(404)
    end
  end


  describe "returns merchant items" do
    it 'happy path' do
      id = create(:merchant).id
      item_ids = create_list(:item, 3, merchant_id: id)

      get "/api/v1/merchants/#{id}/items"

      items = JSON.parse(response.body, symbolize_names: true)
      items_data = items[:data]

      expect(response).to be_successful

      items_data.each do |item|
        expect(item).to have_key(:id)
        expect(item[:id].to_i).to be_a(Integer)

        expect(item[:attributes]).to have_key(:name)
        expect(item[:attributes][:name]).to be_a(String)

        expect(item[:attributes]).to have_key(:description)
        expect(item[:attributes][:description]).to be_a(String)

        expect(item[:attributes]).to have_key(:unit_price)
        expect(item[:attributes][:unit_price]).to be_a(Float)
      end
    end

    it 'sad path: bad id returns 404' do
      id = create(:merchant).id

      get "/api/v1/merchants/#{id}/items"

      expect(response).to_not be_successful
      expect(response.status).to eq(404)
    end
  end
end
