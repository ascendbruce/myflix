Myflix::Application.routes.draw do
  root "pages#front"

  mount StripeEvent::Engine => '/stripe_events'

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
  get "register/:token", to: "users#new_with_invitation_token", as: "register_with_token"
  get "sign_in",  to: "sessions#new"
  get "sign_out", to: "sessions#destroy"


  resource :forgot_password, only: [:new, :create] do
    get :confirm, via: :member
  end
  resources :password_resets, only: [:show, :create]
  get "expired_token", to: "pages#expired_token"

  namespace :admin do
    resources :videos, only: [:new, :create]
    resources :payments, only: :index
  end

  get 'ui(/:action)', controller: 'ui'
end
