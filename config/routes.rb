Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      get '/items/find', to: 'search#find_item'
      get '/items/find_all', to: 'search#find_all_items'
      
      get '/merchants/find', to: 'search#find_merchant'
      get '/merchants/find_all', to: 'search#find_all_merchants'

      resources :merchants, only: [:index, :show]
      get '/merchants/:id/items', to: 'merchant_items#index'

      resources :items, only: [:index, :show, :create, :update, :destroy]
      get '/items/:id/merchant', to: 'items_merchant#show'
    end
  end
end
