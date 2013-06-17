PhotoApp::Application.routes.draw do
  resources :photos, :only => [:index, :show, :create, :destroy] do
    post 'associate', :on => :collection
  end

  authenticated :user do
    root :to => 'photos#index'
  end
  root :to => "home#index"
  devise_for :users
  resources :users

  namespace :admin do
    resources :photos
  end
end