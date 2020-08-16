require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_mailbox/engine"
require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"
# require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SnippetsApi
  class Application < Rails::Application

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins %w[localhost:4000 192.168.2.49:4000 https://pedantic-mcclintock-cb8836.netlify.app https://qwaked.com]
        resource '*', headers: :any, methods: %i[get post patch delete options]
      end
    end

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0
    # config.autoload_paths << Rails.root.join('lib')
    config.autoload_paths += Dir["#{config.root}/lib/**/"]

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true

    # creating constants
    config.x.u_group_types.lesson = 'lesson'

    config.x.u_role_types.lesson_member = 'lesson_member'
    config.x.u_role_types.lesson_owner = 'lesson_owner'


  end
end
