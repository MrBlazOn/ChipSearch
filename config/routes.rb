Rails.application.routes.draw do
  resources :search
  root to: 'search#index'
end
