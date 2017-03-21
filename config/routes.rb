# frozen_string_literal: true
Rails.application.routes.draw do
  devise_for :admins, skip: [:registrations]
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  devise_scope :user do
    authenticated :user do
      root to: 'home#landing'
    end

    unauthenticated :user do
      root to: 'home#index', as: :unauthenticated_root
    end
  end

  resources :units, only: [:index]
  #------------------------------------------------------------------------------
  # ROBOTS
  get '/robots.txt' => RobotsTxt # lib/robots_txt.rb

  #------------------------------------------------------------------------------
  # ERROR ROUTES
  match '/404', to: 'errors#not_found', via: :all
  match '/500', to: 'errors#internal_server_error', via: :all

  #------------------------------------------------------------------------------
  # API ROUTES
  namespace :api do
    namespace :v1 do
      namespace :stripe do
        resources :account, only: [:create]
      end
    end
  end
end
