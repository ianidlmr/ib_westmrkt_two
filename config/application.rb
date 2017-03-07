require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RailwayMrkt
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Make sure lib files are auto loaded
    config.autoload_paths += %W(#{config.root}/lib)

    # For 404 and 500 pages
    config.exceptions_app = self.routes
  end
end
