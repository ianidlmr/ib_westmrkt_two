# frozen_string_literal: true
Rails.application.routes.draw do
  devise_for :admins, skip: [:registrations], controllers: { sessions: 'admins/sessions' }
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  devise_scope :user do
    authenticated :user do
      scope '/units' do
        put ':id/like-unit' => 'likes#like_unit', as: :like_unit
        put ':id/unlike-unit' => 'likes#unlike_unit', as: :unlike_unit
      end
    end
  end

  resources :units, only: [:index, :show] do
    collection do
      post '/search' => 'search#search', as: 'search'
    end
  end

  #------------------------------------------------------------------------------
  # STATIC PAGES
  get '/about' => 'home#about', as: 'about'
  get '/terms-and-privacy' => 'home#terms_and_privacy', as: 'terms_and_privacy'
  root to: 'home#index'

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
