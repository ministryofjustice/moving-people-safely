FROM ministryofjustice/ruby:2.3.0-webapp-onbuild

ENV UNICORN_PORT 3000
EXPOSE $UNICORN_PORT

RUN RAILS_ENV=production SERVICE_URL=foo SMTP_DOMAIN=smtp_domain SMTP_HOSTNAME=smtp_hostname SMTP_PASSWORD=smtp_password SMTP_PORT=587 SMTP_USERNAME=smtp_username SECRET_KEY_BASE=foo exec rake assets:precompile --trace

ENTRYPOINT ["./docker/bin/run.sh"]
