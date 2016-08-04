require 'feature_helper'
require 'capybara/rspec'
require 'database_cleaner'

Capybara.default_driver = :selenium

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

module SlowItDown
  def save_and_continue
    longer_wait
    super
  end

  def fill_in(*)
    short_wait
    super
  end

  def choose(*)
    short_wait
    super
  end

  def select(*)
    short_wait
    super
  end

  def click_link(*)
    short_wait
    super
  end

  def short_wait
    sleep(2)
  end

  def longer_wait
    sleep(4)
  end
end

#Page::Base.prepend SlowItDown
