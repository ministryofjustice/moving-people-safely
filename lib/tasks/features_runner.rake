require 'rspec/core/rake_task'

namespace :features do
  desc 'Runs features using Chrome driver'
  RSpec::Core::RakeTask.new(:firefox) do |t|
    t.pattern = Dir.glob('./spec/features/*_spec.rb')
    t.rspec_opts = '--require ./spec/selenium_helper.rb'
  end
end
