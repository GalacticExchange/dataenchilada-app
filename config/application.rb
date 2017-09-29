require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "active_model/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"
require 'rails/all'
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)
# these gems are not required by Bundler.require
require "draper"
require "sass"
require "haml-rails"
require "jquery-rails"
require "sucker_punch"
require "settingslogic"
require "kramdown-haml"
require "jbuilder"
require "diff/lcs"

module FluentdUi
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = 'en'
    config.autoload_paths += %W(#{config.root}/app/workers #{config.root}/lib)

    # NOTE: currently, fluentd-ui does not using ActiveRecord, and using Time.now instead of Time.zone.now for each different TZ for users.
    #       If AR will be used, please comment in and check timezone.
    # config.active_record.default_timezone = :local
    # config.time_zone =

    require Rails.root.join("lib", "fluentd-ui")

    if ENV["FLUENTD_UI_LOG_PATH"].present?
      config.logger = ActiveSupport::Logger.new(ENV["FLUENTD_UI_LOG_PATH"])
    end
  end
end
