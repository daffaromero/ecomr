Rails.application.routes.draw do
  devise_for :users
  root 'products#index'

  resources :products
  resource :cart, only: [:show] do
    post 'add_item/:product_id', to: 'carts#add_item', as: :add_item
    delete 'remove_item/:product_id', to: 'carts#remove_item', as: :remove_item
  end

  post 'checkout/create', to: 'checkouts#create'
  get 'checkout/success', to: 'checkouts#success'
  get 'checkout/cancel', to: 'checkouts#cancel'

end
