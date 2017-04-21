FROM ministryofjustice/ruby:2.4.0-webapp-onbuild

ENV UNICORN_PORT 3000
EXPOSE $UNICORN_PORT

# Install fonts required for PDF generation and clear font cache
RUN cp -r ./app/assets/fonts/liberation_sans /usr/share/fonts/truetype/
RUN fc-cache -f -v

RUN RAILS_ENV=production npm install -g bower
RUN RAILS_ENV=production bower install --allow-root
RUN RAILS_ENV=production SKIP_OPTIONAL_INITIALIZERS=true SECRET_KEY_BASE=foo exec rake assets:precompile --trace

ENTRYPOINT ["./docker/bin/run.sh"]
