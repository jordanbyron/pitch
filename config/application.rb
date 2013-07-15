require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(:default, Rails.env)

module Pitch
  class Application < Rails::Application
    config.middleware.use 'Apartment::Elevators::Subdomain'

    config.autoload_paths += %w[#{config.root}/lib]

    config.assets.initialize_on_precompile = false

    config.generators do |g|
      g.test_framework :mini_test, spec: true, fixture: false, helper: false,
                                   assets: false
    end
  end
end
