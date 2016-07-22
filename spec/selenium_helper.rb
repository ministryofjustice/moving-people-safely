require 'rails_helper'

require 'capybara/rspec'
require 'database_cleaner'

Capybara.default_driver = :selenium
Capybara.page.driver.browser.manage.window.maximize
RSpec.configure do |config|
  config.use_transactional_fixtures = false

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
    Capybara.page.driver.browser.manage.window.maximize
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
