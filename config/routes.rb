Rails.application.routes.draw do
  
  # Routes for main resources
  resources :addresses
  resources :customers
  resources :orders
  resources :items
  resources :users
  resources :sessions

  # Semi-static page routes
  get 'users/new', to: 'users#new', as: :signup
  get 'user/edit', to: 'users#edit', as: :edit_current_user
  get 'login', to: 'sessions#new', as: :login
  get 'logout', to: 'sessions#destroy', as: :logout
  get 'home' => 'home#home', as: :home
  get 'about' => 'home#about', as: :about
  get 'contact' => 'home#contact', as: :contact
  get 'privacy' => 'home#privacy', as: :privacy
  get 'cart/:id/add' => 'orders#add_to_cart', as: :add_to_cart
  get 'cart/:id/remove' => 'orders#remove_from_cart', as: :remove_from_cart
  get 'addresses/:id/deactivate' => 'addresses#deactivate', as: :address_deactivate
  get 'addresses/:id/activate' => 'addresses#activate', as: :address_activate
  get 'customers/:id/deactivate' => 'customers#deactivate', as: :customer_deactivate
  get 'customers/:id/activate' => 'customers#activate', as: :customer_activate
  get 'users/:id/deactivate' => 'users#deactivate', as: :user_deactivate
  get 'users/:id/activate' => 'users#activate', as: :user_activate
  get 'items/:id/deactivate' => 'items#deactivate', as: :item_deactivate
  get 'items/:id/activate' => 'items#activate', as: :item_activate
  get 'cart' => 'home#cart', as: :cart
  
  # Set the root url
  root :to => 'home#home'
  
end
