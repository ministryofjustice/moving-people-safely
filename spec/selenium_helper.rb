require 'feature_helper'
require 'capybara/rspec'
require 'selenium/webdriver'

module SlowItDown
  def save_and_continue
    super
    longer_wait
  end

  def fill_in(*)
    super
    short_wait
  end

  def choose(*)
    super
    short_wait
  end

  def select(*)
    super
    short_wait
  end

  def click_button(*)
    super
    short_wait
  end

  def click_link(*)
    super
    short_wait
  end

  def short_wait
    sleep(3)
  end

  def longer_wait
    puts 'LONGER WAIT...'
    sleep(5)
  end
end

#Page::Base.prepend SlowItDown
