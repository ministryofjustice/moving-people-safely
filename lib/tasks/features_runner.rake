# frozen_string_literal: true

if %w[development test].include? Rails.env
  require 'rspec/core/rake_task'

  desc 'Runs features using a browser'
  RSpec::Core::RakeTask.new(:features) do |t|
    t.rspec_opts =
      '--require ./spec/selenium_helper.rb --tag type:system --exclude-pattern "spec/system/printing_*.rb"'
  end
end
