require 'rails_helper'

RSpec.describe 'The item API' do
  describe "returns all items" do
    it 'happy path' do
      merchant_1 = create(:merchant)
      merchant_1_items = create_list(:item, 3, merchant_id: merchant_1.id)

      merchant_2 = create(:merchant)
      merchant_1_items = create_list(:item, 3, merchant_id: merchant_2.id)

      get '/api/v1/items'

      items = JSON.parse(response.body, symbolize_names: true)
      items_data = items[:data]

      expect(response).to be_successful
      expect(items_data.count).to eq(6)

      items_data.each do |item|
        expect(item).to have_key(:id)
        expect(item[:id].to_i).to be_an(Integer)

        expect(item[:attributes]).to have_key(:name)
        expect(item[:attributes][:name]).to be_a(String)

        expect(item[:attributes]).to have_key(:description)
        expect(item[:attributes][:description]).to be_a(String)

        expect(item[:attributes]).to have_key(:unit_price)
        expect(item[:attributes][:unit_price]).to be_a(Float)
      end
    end
  end


  describe "returns one merchant" do
    it 'happy path' do
      merchant_1 = create(:merchant)
      show_item = create(:item, merchant_id: merchant_1.id)

      get "/api/v1/items/#{show_item.id}"

      item = JSON.parse(response.body, symbolize_names: true)
      item_data = item[:data]

      expect(response).to be_successful

      expect(item_data).to have_key(:id)
      expect(item_data[:id].to_i).to be_an(Integer)

      expect(item_data[:attributes]).to have_key(:name)
      expect(item_data[:attributes][:name]).to be_a(String)

      expect(item_data[:attributes]).to have_key(:description)
      expect(item_data[:attributes][:description]).to be_a(String)

      expect(item_data[:attributes]).to have_key(:unit_price)
      expect(item_data[:attributes][:unit_price]).to be_a(Float)
    end

    it 'sad path: bad item id returns 404' do
      non_item_id = 10000000000

      get "/api/v1/items/#{non_item_id}"

      expect(response).to_not be_successful
      expect(response.status).to eq(404)
    end

    it 'edge case: string id returns 404' do
      non_item_id = "10000000000"

      get "/api/v1/merchants/#{non_item_id}"

      expect(response).to_not be_successful
      expect(response.status).to eq(404)
    end
  end


  describe "creates a new item" do
    it 'happy path' do
      merchant_1 = create(:merchant)
      item_params = ({
                      name: 'Paraglider',
                      description: 'XL Buzz Z6 Paraglider',
                      unit_price: 3500.0,
                      merchant_id: merchant_1.id
                    })
      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)
      created_item = Item.last

      expect(response).to be_successful
      expect(created_item.name).to eq(item_params[:name])
      expect(created_item.description).to eq(item_params[:description])
      expect(created_item.unit_price).to eq(item_params[:unit_price])
      expect(created_item.merchant_id).to eq(item_params[:merchant_id])
    end

    it 'sad path' do
      merchant_1 = create(:merchant)
      item_params = ({ unit_price: 3500.0 })
      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)
      created_item = Item.last

      expect(response).to_not be_successful
      expect(response.status).to eq(400)
    end
  end


  describe "updates an existing item" do
    it 'happy path' do
      merchant_1 = create(:merchant)
      old_item = create(:item, merchant_id: merchant_1.id)
      previous_name = Item.last.name
      item_params = { name: "Renamed Item" }
      headers = {"CONTENT_TYPE" => "application/json"}

      patch "/api/v1/items/#{old_item.id}", headers: headers, params: JSON.generate({item: item_params})
      updated_item = Item.find_by(id: old_item.id)

      expect(response).to be_successful
      expect(updated_item.name).to_not eq(previous_name)
      expect(updated_item.name).to eq("Renamed Item")
    end

    it "sad path: bad integer id returns 404" do
      merchant_1 = create(:merchant)
      old_item = create(:item, merchant_id: merchant_1.id)
      previous_name = Item.last.name
      incorrect_id = 10000000000
      item_params = { name: "Renamed Item", merchant_id: incorrect_id }
      headers = {"CONTENT_TYPE" => "application/json"}

      patch "/api/v1/items/#{old_item.id}", headers: headers, params: JSON.generate({item: item_params})

      expect(response).to_not be_successful
      expect(response.status).to eq(404)
    end

    it "edge case: string id returns 404" do
      merchant_1 = create(:merchant)
      old_item = create(:item, merchant_id: merchant_1.id)
      previous_name = Item.last.name
      incorrect_id = "hello world"
      item_params = { name: "Renamed Item", merchant_id: incorrect_id }
      headers = {"CONTENT_TYPE" => "application/json"}

      patch "/api/v1/items/#{old_item.id}", headers: headers, params: JSON.generate({item: item_params})

      expect(response).to_not be_successful
      expect(response.status).to eq(404)
    end
  end


  describe "can delete an item" do
    it 'happy path' do
      merchant_1 = create(:merchant)
      item = create(:item, merchant_id: merchant_1.id)

      expect(Item.count).to eq(1)

      delete "/api/v1/items/#{item.id}"

      expect(response).to be_successful
      expect(Item.count).to eq(0)
      expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
    end
  end


  describe "returns merchant data for the given item id" do
    it 'happy path' do
      merchant_1 = create(:merchant)
      merchant_1_item = create(:item, merchant_id: merchant_1.id)

      get "/api/v1/items/#{merchant_1_item.id}/merchant"

      merchant = JSON.parse(response.body, symbolize_names: true)
      merchant_data = merchant[:data]

      expect(response).to be_successful

      expect(merchant_data).to have_key(:id)
      expect(merchant_data[:id].to_i).to eq(merchant_1.id)

      expect(merchant_data[:attributes]).to have_key(:name)
      expect(merchant_data[:attributes][:name]).to be_a(String)
    end

    it 'sad path: bad id returns 404' do
      incorrect_item_id = 10000000000

      get "/api/v1/items/#{incorrect_item_id}/merchant"

      expect(response).to_not be_successful
      expect(response.status).to eq(404)
    end
  end
end
