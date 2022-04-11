Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html


  get "merchants/:merchant_id/dashboard", to: "merchants#show"
  get "merchants/:merchant_id/items", to: "items#index"
  get "merchants/:merchant_id/items/new", to: "items#new"
  get "merchants/:merchant_id/invoices", to: "invoices#index"
  get "merchants/:merchant_id/items/:item_id", to: "items#show"
  get "merchants/:merchant_id/items/:item_id/edit", to: "items#edit"
  post "merchants/:merchant_id/items", to: "items#create"
  patch "merchants/:merchant_id/items/:item_id", to: "items#update"


  get 'merchants/:id/invoices/:invoice_id', to: 'invoices#show'
  #get "merchants/:id/items/:id", to: "items#show"
  #patch 'merchants/:id/items', to: 'items#update'

end
