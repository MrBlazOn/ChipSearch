Rails.application.routes.draw do
  resources :products
  resources :search
  root to: 'search#index'
  match '/search' => 'search_results#index', via: :get
end
