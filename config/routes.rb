Rails.application.routes.draw do
  devise_for :users

  get '/robots.txt' => RobotsTxt # lib/robots_txt.rb
end
