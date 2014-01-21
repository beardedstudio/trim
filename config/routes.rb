Rails.application.routes.draw do
  resources :nav_items, :only => :show

  resources :pages, :only => :show

  root to: 'home#index'

  filter :navigation
end
