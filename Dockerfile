FROM ruby:2.6.3

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update && apt-get install -y nodejs yarn && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && rm -fr *Release* *Sources* *Packages* && \
    truncate -s 0 /var/log/*log

RUN addgroup --gid 1000 appgroup && \
    adduser appuser --uid 1000 --home /usr/src/app --ingroup appgroup --shell /bin/bash --disabled-password --gecos ""

WORKDIR /usr/src/app

COPY Gemfile /usr/src/app/
COPY Gemfile.lock /usr/src/app/

RUN bundle config --global without test:development
RUN bundle config --global disable_shared_gems 1
RUN bundle install

COPY . /usr/src/app
RUN mkdir -p /usr/src/app/public/assets
RUN chown -R appuser:appgroup /usr/src/app

## Install fonts required for PDF generation and clear font cache
RUN cp -r ./app/assets/fonts/liberation_sans /usr/share/fonts/truetype/
RUN fc-cache -f -v

## Set version env vars
ARG APP_BUILD_TAG=1_0_0
ARG APP_GIT_COMMIT=dummy
ARG APP_BUILD_DATE=dummy

RUN echo $APP_BUILD_TAG > app_build_tag.txt && \
    echo $APP_GIT_COMMIT > app_git_commit.txt && \
    echo $APP_BUILD_DATE > app_build_date.txt

USER 1000

RUN RAILS_ENV=production SKIP_OPTIONAL_INITIALIZERS=true SECRET_KEY_BASE=foo exec rake assets:precompile --trace

EXPOSE 3000

ENTRYPOINT ["./docker/bin/run.sh"]
