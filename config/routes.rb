Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get "merchants/:id/dashboard", to: "merchants#show"
  get "merchants/:id/items", to: "items#index"
  get "merchants/:id/items/new", to: "items#new"
  get "merchants/:id/invoices", to: "invoices#index"
  get "merchants/:merchant_id/items/:id", to: "items#show"
  get "merchants/:merchant_id/items/:id/edit", to: "items#edit"
  post "/merchants/:merchant_id/items", to: "items#create"
  patch "merchants/:merchant_id/items/:id", to: "items#update"
end
