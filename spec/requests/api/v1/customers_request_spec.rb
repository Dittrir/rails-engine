require 'rails_helper'

RSpec.describe 'The customer API' do
  it 'sends a list of customers' do
    create_list(:customer, 3)

    get '/api/v1/customers'

    customers = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(customers.count).to eq(3)
  end
end
