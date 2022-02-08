Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :merchants, only: [:index, :show] do
        resources :items, only: [:index]
      end
      resources :items, only: [:index, :show, :create, :update, :destroy]
      resources :customers, only: [:index]
      # resources :invoices, only: [:index]
      # resources :invoice_items, only: [:index]
      # resources :transactions, only: [:index]
    end
  end
end
