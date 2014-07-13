Myflix::Application.routes.draw do
  root "pages#front"

  get "home" => "videos#index"

  resources :videos, :only => [:index, :show] do
    resources :reviews, :only => [:create]
    get "search", on: :collection
    post "add_to_my_queue", on: :collection
  end

  resources :queue_items, :only => [:destroy] do
    put "update_my_queue", on: :collection
  end
  resources :invitations, only: [:new, :create]

  resources :categories, :only => [:show]
  resources :users,      :only => [:new, :create, :show]
  get "people", to: "relationships#index"
  resources :relationships, :only => [:create, :destroy]

  resources :sessions,   :only => [:create]

  get "my_queue", to: "pages#my_queue", as: "my_queue"

  get "register", to: "users#new"
  get "sign_in",  to: "sessions#new"
  get "sign_out", to: "sessions#destroy"


  resource :forgot_password, only: [:new, :create] do
    get :confirm, via: :member
  end
  resources :password_resets, only: [:show, :create]
  get "expired_token", to: "password_resets#expired_token"

  get 'ui(/:action)', controller: 'ui'
end
