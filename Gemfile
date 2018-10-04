source 'https://rubygems.org'

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

gem 'aws-sdk-s3'
gem 'bootsnap', require: false
gem 'cancancan'
gem 'connection_pool'
gem 'countries'
gem 'custom_error_message', git: 'https://github.com/thethanghn/custom-err-msg.git'
gem 'datafix', git: 'https://github.com/Casecommons/datafix.git'
gem 'deep_cloneable'
gem 'excon'
gem 'faraday'
gem 'geckoboard-ruby'
gem 'govuk_elements_form_builder'
gem 'govuk_elements_rails'
gem 'govuk_frontend_toolkit'
gem 'govuk_template'
gem 'jquery-rails'
gem 'logstasher'
gem 'omniauth-oauth2', '~> 1.3.1' # do not remove version
gem 'paperclip'
gem 'pg'
gem 'puma'
gem 'rails', '~> 5.2'
gem 'reform', '2.1.0' # do not remove version
gem 'reform-rails'
gem 'sass-rails'
gem 'sentry-raven'
gem 'slim-rails'
gem 'uglifier'
gem 'virtus'
gem 'wicked'
gem 'wicked_pdf'
gem 'wkhtmltopdf-binary'
gem 'zendesk_api'

group :development, :test do
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'jasmine'
  gem 'jasmine-jquery-rails'
  gem 'pdftotext'
  gem 'pry-byebug'
  gem 'pry-rails'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'listen'
  gem 'meta_request'
  gem 'rubocop', require: false
  gem 'spring'
  gem 'spring-watcher-listen'
end

group :test do
  gem 'capybara'
  gem 'chromedriver-helper'
  gem 'climate_control'
  gem 'codeclimate-test-reporter', require: nil
  gem 'database_cleaner'
  gem 'diffy'
  gem 'launchy'
  gem 'rspec-its'
  gem 'rspec-rails'
  gem 'selenium-webdriver'
  # TODO: update to 4.x once issue resolved https://github.com/thoughtbot/shoulda-matchers/issues/1146
  gem 'shoulda-matchers', github: 'thoughtbot/shoulda-matchers', ref: '43f4252'
  gem 'simplecov', require: false
  gem 'site_prism'
  gem 'webmock'
end
