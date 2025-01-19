Rails.application.routes.draw do
  mount RailsAdmin::Engine => "/admin", as: "rails_admin"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  root "top#index"
  get "geojson", to: "top#municipality_spot_counts"

  get "privacy_policy", to: "top#privacy_policy"
  get "site_policy", to: "top#site_policy"
  resources :contacts, only: %i[new create] do
    collection do
      post :confirm
      get :done
    end
  end

  resources :users, only: %i[new create show] do
    resources :lists, only: %i[index show create update destroy]
  end
  get "login", to: "user_sessions#new"
  post "login", to: "user_sessions#create"
  delete "logout", to: "user_sessions#destroy"

  post "oauth/callback", to: "oauths#callback"
  get "oauth/callback", to: "oauths#callback"
  get "oauth/:provider", to: "oauths#oauth", as: :auth_at_provider

  get "posts_browse", to: "top#posts_browse"

  resources :spots, only: %i[new create] do
    collection do
      get :get_municipalities
      get :select
      post :confirm
    end
    resources :posts
  end
  resources :municipalities, only: %i[index]
  resources :images, only: %i[destroy]

  resources :bookmarks, only: %i[create destroy]

  resource :profile, only: %i[show edit update destroy] do
    collection do
      get :myposts
      get :unsubscribe
    end
  end

  resources :password_resets, only: %i[new create edit update]

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  get "/health", to: proc { [ 200, {}, [ "OK" ] ] }

  match "*unmatched", to: "application#rescue_to_404", via: :all
end
