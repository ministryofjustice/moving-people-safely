#!/bin/bash
export RAILS_ENV=production
cd /usr/src/app
case ${DOCKER_STATE} in
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
bundle exec rails server -d --binding 0.0.0.0
tail -f log/${RAILS_ENV}.log
