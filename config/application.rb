require_relative "boot"

# Monkey patch for Ruby 3.3 compatibility
require 'logger'
module ActiveSupport
  module LoggerThreadSafeLevel
    Logger = ::Logger
  end
end

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Backend
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Fix for Ruby 3.3 compatibility
    config.active_support.logger_outputs_to = [:stdout]

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true

    config.generators do |g|
      g.test_framework :rspec,
                       fixtures: false,
                       helper_specs: false,
                       view_specs: false,
                       routing_specs: false
    end

    config.time_zone = "Asia/Tokyo"
    config.active_record.default_timezone = :local
    config.autoload_paths += %W(#{config.root}/lib)
  end
end
