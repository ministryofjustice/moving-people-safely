if %w[development test].include? Rails.env
  require 'scss_lint/rake_task'
  SCSSLint::RakeTask.new

  task(:default).prerequisites << task(:scss_lint)
end
