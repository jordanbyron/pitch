require_relative '../test_helper'
require 'minitest/rails/capybara'

require_relative '../support/feature_screenshot'

DatabaseCleaner.strategy   = :truncation
Capybara.javascript_driver = :webkit

class Capybara::Rails::TestCase
  self.use_transactional_fixtures = false

  before :each do
    if metadata[:js] == true
      Capybara.current_driver = Capybara.javascript_driver
    end
    DatabaseCleaner.start
  end

  after :each do |context|
    FeatureScreenshot[context]

    DatabaseCleaner.clean

    Capybara.current_driver = Capybara.default_driver
  end
end
