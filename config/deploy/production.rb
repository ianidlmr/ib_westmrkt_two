# frozen_string_literal: true
# server-based syntax
# ======================
# Defines a single server with a list of roles and multiple properties.
# You can define all roles on a single server, or split them:

# server "example.com", user: "deploy", roles: %w{app db web}, my_property: :my_value
# server "example.com", user: "deploy", roles: %w{app web}, other_property: :other_value
# server "db.example.com", user: "deploy", roles: %w{db}

# web
server '52.60.205.109', user: 'deploy', roles: %w(app db puma_role), primary: true

# utility
server '52.60.174.146', user: 'deploy', roles: %w(app cron)

# Configuration
# =============
# You can set any configuration variable like in config/deploy.rb
# These variables are then only loaded and set in this stage.
# For available Capistrano configuration variables see the documentation page.
# http://capistranorb.com/documentation/getting-started/configuration/
# Feel free to add new variables to customise your setup.

set :stage, :production
set :branch, ENV['REVISION'] || ENV['BRANCH_NAME'] || :master

set :deploy_to, '/home/deploy/www'
set :rvm_ruby_version, '2.4.0@westmarket'
set :linked_files, %w(config/puma.rb)

# Tasks
# ======

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:puma_role), in: :sequence, wait: 5 do
      execute 'sudo restart puma-manager'
    end
  end

  after  :finishing, :cleanup
  after  :finishing, :restart
end
