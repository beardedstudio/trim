Rails.application.routes.draw do
  
  filter :navigation

  scope module: 'trim' do
    root :to => 'home#index'

    resources :nav_items, :only => :show

    resources :pages, :only => :show
  end


end
