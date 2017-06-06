# frozen_string_literal: true
# config valid only for current version of Capistrano
lock '3.8.0'

set :application, 'west-mrkt-duplicate'
set :repo_url, 'git@github.com:ianidlmr/ib_westmrkt_two.git'

# Default value for :log_level is :debug
set :log_level, :info

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp
set :scm, :git
set :branch, "duplicate"
# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/var/www/my_app_name"

# Default value for :format is :airbrussh.
# set :format, :airbrussh
set :rails_env, "production"
set :deploy_via, :copy
# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml", "config/secrets.yml"

# Default value for linked_dirs is []
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets'

set :assets_roles, [:puma_role] # Defaults to [:web]

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

# https://github.com/javan/whenever#capistrano-v3-integration
set :whenever_identifier, -> { "#{fetch(:application)}_#{fetch(:stage)}" }

# 'db' is the default whenever role
set :whenever_roles, [:cron]
