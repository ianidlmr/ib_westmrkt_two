Rails.application.routes.draw do
  devise_for :users

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