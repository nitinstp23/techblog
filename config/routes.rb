Teckblog::Application.routes.draw do

  resources :posts do
    get 'page/:page', action: :index, on: :collection
  end

  root 'posts#index'
end
