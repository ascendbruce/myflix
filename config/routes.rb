Myflix::Application.routes.draw do
  root "pages#front"

  get "home" => "videos#index"

  resources :videos, :only => [:index, :show] do
    resources :reviews, :only => [:create]
    get "search", on: :collection
    post "add_to_my_queue", on: :collection
  end

  resources :queue_items, :only => [:destroy]
  resources :categories, :only => [:show]
  resources :users,      :only => [:new, :create]
  resources :sessions,   :only => [:create]

  get "my_queue", to: "pages#my_queue", as: "my_queue"

  get "register", to: "users#new"
  get "sign_in",  to: "sessions#new"
  get "sign_out", to: "sessions#destroy"

  get 'ui(/:action)', controller: 'ui'
end
