FROM ministryofjustice/ruby:2.3.0-webapp-onbuild

ENV UNICORN_PORT 3000
EXPOSE $UNICORN_PORT

RUN RAILS_ENV=production npm install -g bower
RUN RAILS_ENV=production bower install --allow-root
RUN RAILS_ENV=production SECRET_KEY_BASE=foo exec rake assets:precompile --trace

ENTRYPOINT ["./docker/bin/run.sh"]
