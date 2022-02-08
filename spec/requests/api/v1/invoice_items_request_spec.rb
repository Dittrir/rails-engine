# require 'rails_helper'
#
# RSpec.describe 'The invoice item API' do
#   it 'sends a list of invoice items' do
#     create_list(:invoice_item, 3)
#
#     get '/api/v1/invoice_items'
#
#     invoice_items = JSON.parse(response.body, symbolize_names: true)
#
#     expect(response).to be_successful
#     expect(invoice_items.count).to eq(3)
#   end
# end
