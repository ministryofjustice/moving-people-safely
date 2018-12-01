if %w[development test].include? Rails.env
  require 'slim_lint/rake_task'
  SlimLint::RakeTask.new

  task(:default).prerequisites << task(:slim_lint)
end
