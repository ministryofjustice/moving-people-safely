require 'feature_helper'
require 'capybara/rspec'
require 'selenium/webdriver'

Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end

Capybara.register_driver :headless_chrome do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
    chromeOptions: { args: %w(headless disable-gpu) }
  )

  Capybara::Selenium::Driver.new app,
    browser: :chrome,
    desired_capabilities: capabilities
end

Capybara.default_driver = (ENV.fetch('HEADLESS_FEATURES', 'true') == 'true' ? :headless_chrome : :chrome)

RSpec.configure do |config|
  config.use_transactional_fixtures = false
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
