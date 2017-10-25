#!/bin/bash
export RAILS_ENV=production
cd /usr/src/app
case ${DOCKER_STATE} in
setup)
    echo "running setup"
    bundle exec rails db:setup
    bundle exec rails db:migrate
    bundle exec rails db:seed
    ;;
create)
    echo "running create"
    bundle exec rails db:setup db:seed
    ;;
migrate_and_seed)
    echo "running migrate and seed"
    bundle exec rails db:migrate db:seed
    ;;
drop_and_create)
    echo "running drop and create"
    bundle exec rails db:drop db:setup db:seed
    ;;
esac
bundle exec rails server --binding 0.0.0.0
