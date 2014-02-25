Techblog::Application.routes.draw do

  resources :users, only: [:edit, :update]

  resources :sessions, only: [:new, :create, :destroy]

  resources :posts, except: [:edit, :update, :destroy] do
    get 'page/:page', action: :index, on: :collection
  end

  root 'posts#index'

end
