Rails.application.routes.draw do
  devise_for :users

  get '/robots.txt' => RobotsTxt # lib/robots_txt.rb

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