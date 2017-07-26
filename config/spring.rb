%w(
  .env
  .ruby-version
  .rbenv-vars
  config/assessments_schema.yml
  tmp/restart.txt
  tmp/caching-dev.txt
).each { |path| Spring.watch(path) }
