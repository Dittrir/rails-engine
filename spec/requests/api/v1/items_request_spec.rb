require 'rails_helper'

RSpec.describe 'The item API' do
  it 'sends a list of items' do
    merchant_1 = create(:merchant)
    merchant_1_items = create_list(:item, 3, merchant_id: merchant_1.id)

    merchant_2 = create(:merchant)
    merchant_1_items = create_list(:item, 3, merchant_id: merchant_2.id)

    get '/api/v1/items'

    items = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(items.count).to eq(6)

    items.each do |item|
      expect(item).to have_key(:id)
      expect(item[:id]).to be_an(Integer)

      expect(item).to have_key(:name)
      expect(item[:name]).to be_a(String)

      expect(item).to have_key(:description)
      expect(item[:description]).to be_a(String)

      expect(item).to have_key(:unit_price)
      expect(item[:unit_price]).to be_a(Float)
    end
  end

  it 'can get one item by its id' do
    merchant_1 = create(:merchant)
    merchant_1_items = create_list(:item, 3, merchant_id: merchant_1.id)
    show_item = create(:item, merchant_id: merchant_1.id)

    get "/api/v1/items/#{show_item.id}"

    item = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful

    expect(item).to have_key(:id)
    expect(item[:id]).to be_an(Integer)

    expect(item).to have_key(:name)
    expect(item[:name]).to be_a(String)

    expect(item).to have_key(:description)
    expect(item[:description]).to be_a(String)

    expect(item).to have_key(:unit_price)
    expect(item[:unit_price]).to be_a(Float)
  end

  it 'can create a new item' do
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

  it "can update an existing item" do
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

  it "can delete an item" do
    merchant_1 = create(:merchant)
    item = create(:item, merchant_id: merchant_1.id)

    expect(Item.count).to eq(1)

    delete "/api/v1/items/#{item.id}"

    expect(response).to be_successful
    expect(Item.count).to eq(0)
    expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end

  xit 'can get the merchant data for the given item id' do
    id = create(:merchant).id

    get "/api/v1/merchants/#{id}"

    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful

    expect(merchant).to have_key(:id)
    expect(merchant[:id]).to eq(id)

    expect(merchant).to have_key(:name)
    expect(merchant[:name]).to be_a(String)
  end
end
