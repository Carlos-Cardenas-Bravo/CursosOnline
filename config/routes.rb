Rails.application.routes.draw do
#  get '/run_seed', to: 'application#run_seed'
  get "/dashboard", to: "dashboards#show", as: :dashboard
  resources :enrollments
  resources :courses do
    member do
      get :progress
    end
    collection do
      get :analytics
    end
  end
  root "welcome#index"

  get "users/profile"
  devise_for :users
  get "profile", to: "users#profile", as: :user_profile

  # Health check y configuración PWA
  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
