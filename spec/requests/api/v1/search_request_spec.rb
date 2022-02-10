require 'rails_helper'

RSpec.describe 'The search API' do
  describe "finds one merchant by name" do
    it 'happy path' do
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

    it 'sad path: no results found' do
      merchants = create_list(:merchant, 10)

      get "/api/v1/merchants/find?name=sfasfdasd"

      return_value = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(response.status).to eq(200)
      expect(return_value[:data][:message]).to eq("There were no matches")
    end

    it 'edge case: no params given' do
      merchants = create_list(:merchant, 10)

      get "/api/v1/merchants/find"

      return_value = JSON.parse(response.body, symbolize_names: true)

      expect(response).to_not be_successful
      expect(response.status).to eq(400)
      expect(return_value[:data][:message]).to eq("Insufficent query parameters")
    end

    it 'edge case: no name given' do
      merchants = create_list(:merchant, 10)

      get "/api/v1/merchants/find?name="

      return_value = JSON.parse(response.body, symbolize_names: true)

      expect(response).to_not be_successful
      expect(response.status).to eq(400)
      expect(return_value[:data][:message]).to eq("Insufficent query parameters")
    end
  end


  describe "finds all merchants by name" do
    it 'happy path' do
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

    it 'sad path: no results found' do
      merchants = create_list(:merchant, 10)

      get "/api/v1/merchants/find_all?name=NOMATCH"

      return_value = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(response.status).to eq(200)
    end

    it 'edge case: no params given' do
      merchants = create_list(:merchant, 10)

      get "/api/v1/merchants/find_all"

      return_value = JSON.parse(response.body, symbolize_names: true)

      expect(response).to_not be_successful
      expect(response.status).to eq(400)
      expect(return_value[:data][:message]).to eq("Insufficent query parameters")
    end

    it 'edge case: no name given' do
      merchants = create_list(:merchant, 10)

      get "/api/v1/merchants/find_all?name="

      return_value = JSON.parse(response.body, symbolize_names: true)

      expect(response).to_not be_successful
      expect(response.status).to eq(400)
      expect(return_value[:data][:message]).to eq("Insufficent query parameters")
    end
  end

  describe "finds one item" do
    describe "by name" do
      it 'happy path' do
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

      it 'sad path: no match found' do
        items = create_list(:item, 10)

        get "/api/v1/items/find?name=asffrwreds"

        return_value = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful
        expect(response.status).to eq(200)
        expect(return_value[:data][:message]).to eq("There were no matches")
      end

      it 'edge case: no params given' do
        items = create_list(:item, 10)

        get "/api/v1/items/find"

        return_value = JSON.parse(response.body, symbolize_names: true)

        expect(response).to_not be_successful
        expect(response.status).to eq(400)
        expect(return_value[:data][:message]).to eq("Insufficent query parameters")
      end

      it 'edge case: no name given' do
        items = create_list(:item, 10)

        get "/api/v1/items/find?name="

        return_value = JSON.parse(response.body, symbolize_names: true)

        expect(response).to_not be_successful
        expect(response.status).to eq(400)
        expect(return_value[:data][:message]).to eq("Insufficent query parameters")
      end
    end


    describe "by min price" do
      it 'happy path' do
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

      it 'sad path: price too low and no match found' do
        merchant_1 = create(:merchant)
        other_items = create_list(:item, 10, merchant_id: merchant_1.id)

        get "/api/v1/items/find?min_price=0"

        return_value = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful
        expect(response.status).to eq(200)
      end

      it 'edge case: min price cannot be less than 0' do
        merchant_1 = create(:merchant)
        other_items = create_list(:item, 10, merchant_id: merchant_1.id)

        get "/api/v1/items/find?min_price=-1"

        return_value = JSON.parse(response.body, symbolize_names: true)

        expect(response).to_not be_successful
        expect(response.status).to eq(400)
        expect(return_value[:error]).to eq("Error Message: Price parameters can't be less than 0")
      end

      it 'edge case: min price cannot be blank' do
        merchant_1 = create(:merchant)
        other_items = create_list(:item, 10, merchant_id: merchant_1.id)

        get "/api/v1/items/find?min_price="

        return_value = JSON.parse(response.body, symbolize_names: true)

        expect(response).to_not be_successful
        expect(response.status).to eq(400)
        expect(return_value[:data][:message]).to eq("Insufficent query parameters")
      end
    end


    describe "by max price" do
      it 'happy path' do
        merchant_1 = create(:merchant)
        merchant_2 = create(:merchant)
        target_item = create(:item, unit_price: 1234567, merchant_id: merchant_1.id)
        non_search_item_1 = create(:item, name: 'Ski Bindings', merchant_id: merchant_1.id)
        non_search_item_2 = create(:item, name: 'Art Supplies', merchant_id: merchant_2.id)
        non_search_item_3 = create(:item, name: 'Bazooka', merchant_id: merchant_2.id)

        get "/api/v1/items/find?max_price=1234568"

        search_item = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful
        expect(search_item.count).to eq(1)

        item = search_item[:data]

        expect(item).to have_key(:id)
        expect(item[:id].to_i).to be_an(Integer)

        expect(item[:attributes]).to have_key(:name)
        expect(item[:attributes][:name]).to eq("#{target_item.name}")

        expect(item[:attributes]).to have_key(:description)
        expect(item[:attributes][:description]).to eq("#{target_item.description}")

        expect(item[:attributes]).to have_key(:unit_price)
        expect(item[:attributes][:unit_price]).to eq(target_item.unit_price)
      end

      it 'sad path: price too high and no matches found' do
        target_item_1 = create(:item, name: 'Target1')
        other_items = create_list(:item, 10)

        get "/api/v1/items/find?min_price=10000000"

        return_value = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful
        expect(response.status).to eq(200)
        expect(return_value[:data][:message]).to eq("There were no matches")
      end

      it 'edge case: max price cannot be less than 0' do
        merchant_1 = create(:merchant)
        other_items = create_list(:item, 10, merchant_id: merchant_1.id)

        get "/api/v1/items/find?max_price=-1"

        return_value = JSON.parse(response.body, symbolize_names: true)

        expect(response).to_not be_successful
        expect(response.status).to eq(400)
        expect(return_value[:error]).to eq("Error Message: Price parameters can't be less than 0")
      end

      it 'edge case: max price cannot be blank' do
        merchant_1 = create(:merchant)
        other_items = create_list(:item, 10, merchant_id: merchant_1.id)

        get "/api/v1/items/find?max_price="

        return_value = JSON.parse(response.body, symbolize_names: true)

        expect(response).to_not be_successful
        expect(response.status).to eq(400)
        expect(return_value[:data][:message]).to eq("Insufficent query parameters")
      end
    end


    describe "by max and min price" do
      it 'happy path' do
        merchant_1 = create(:merchant)
        merchant_2 = create(:merchant)
        target_item = create(:item, unit_price: 1234567, merchant_id: merchant_1.id)
        non_search_item_1 = create(:item, name: 'Ski Bindings', merchant_id: merchant_1.id)

        get "/api/v1/items/find?min_price=1234566&max_price=1234568"

        search_item = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful
        expect(search_item.count).to eq(1)

        item = search_item[:data]

        expect(item).to have_key(:id)
        expect(item[:id].to_i).to be_an(Integer)

        expect(item[:attributes]).to have_key(:name)
        expect(item[:attributes][:name]).to eq("#{target_item.name}")

        expect(item[:attributes]).to have_key(:description)
        expect(item[:attributes][:description]).to eq("#{target_item.description}")

        expect(item[:attributes]).to have_key(:unit_price)
        expect(item[:attributes][:unit_price]).to eq(target_item.unit_price)
      end

      it 'sad path: no match found' do
        merchant_1 = create(:merchant)
        other_items = create_list(:item, 10, merchant_id: merchant_1.id)

        get "/api/v1/items/find?min_price=5000&min_price=5001"

        return_value = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful
        expect(response.status).to eq(200)
      end

      it 'edge case: cannot send name and min price' do
        merchant_1 = create(:merchant)
        other_items = create_list(:item, 10, merchant_id: merchant_1.id)

        get "/api/v1/items/find?name=ring&min_price=50"

        return_value = JSON.parse(response.body, symbolize_names: true)

        expect(response).to_not be_successful
        expect(response.status).to eq(400)
        expect(return_value[:data][:message]).to eq("Insufficent query parameters")
      end

      it 'edge case: cannot send name and max price' do
        merchant_1 = create(:merchant)
        other_items = create_list(:item, 10, merchant_id: merchant_1.id)

        get "/api/v1/items/find?name=ring&max_price=50"

        return_value = JSON.parse(response.body, symbolize_names: true)

        expect(response).to_not be_successful
        expect(response.status).to eq(400)
        expect(return_value[:data][:message]).to eq("Insufficent query parameters")
      end

      it 'edge case: min_price cannot be more than max_price' do
        merchant_1 = create(:merchant)
        merchant_2 = create(:merchant)
        target_item = create(:item, unit_price: 1234567, merchant_id: merchant_1.id)
        non_search_item_1 = create(:item, name: 'Ski Bindings', merchant_id: merchant_1.id)

        get "/api/v1/items/find?min_price=50&max_price=5"

        return_value = JSON.parse(response.body, symbolize_names: true)

        expect(response).to_not be_successful
        expect(response.status).to eq(400)
        expect(return_value[:data][:message]).to eq("Min price can't be more than max price")
      end
    end
  end


  describe "find all items by name" do
    it 'happy path' do
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

    it 'sad path: no results found' do
      items = create_list(:item, 10)

      get "/api/v1/items/find_all?name=NOMATCH"

      return_value = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(response.status).to eq(200)
    end

    it 'edge case: no param given for find all items by name' do
      items = create_list(:item, 10)

      get "/api/v1/items/find_all"

      return_value = JSON.parse(response.body, symbolize_names: true)

      expect(response).to_not be_successful
      expect(response.status).to eq(400)
      expect(return_value[:data][:message]).to eq("Insufficent query parameters")
    end

    it 'edge case: name cannot be blank' do
      items = create_list(:item, 10)

      get "/api/v1/items/find_all?name="

      return_value = JSON.parse(response.body, symbolize_names: true)

      expect(response).to_not be_successful
      expect(response.status).to eq(400)
      expect(return_value[:data][:message]).to eq("Insufficent query parameters")
    end
  end
end
