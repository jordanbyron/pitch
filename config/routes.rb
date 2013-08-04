Pitch::Application.routes.draw do
  devise_for :users

  root to: 'home#index'

  resources :proposals do
    resources :rows
  end
end
