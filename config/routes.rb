Iz::Application.routes.draw do
 
  devise_for :users
  root to: 'main#index'

  resources :dashboard, only: :index
  resources :places
  resources :services
  resources :transactions
  resources :about, only: :index
  resources :feedback
  end
