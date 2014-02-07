Teckblog::Application.routes.draw do

  resources :posts, only: [:index, :show]

  root 'posts#index'
end
