Pitch::Application.routes.draw do
  devise_for :users

  root to: 'home#index'

  resources :proposals do
    member do
      get 'stream'
    end
    resources :rows
  end
end
