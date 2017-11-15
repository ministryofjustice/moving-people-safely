# Moving People Safely

[![CircleCI](https://circleci.com/gh/ministryofjustice/moving-people-safely.svg?style=svg)](https://circleci.com/gh/ministryofjustice/moving-people-safely) [![Code Climate](https://codeclimate.com/github/ministryofjustice/moving-people-safely/badges/gpa.svg)](https://codeclimate.com/github/ministryofjustice/moving-people-safely) [![Test Coverage](https://codeclimate.com/github/ministryofjustice/moving-people-safely/badges/coverage.svg)](https://codeclimate.com/github/ministryofjustice/moving-people-safely/coverage)

# Instalation

**NOTE:** These steps assume the commands are being run from the root of the project.

## Requirements

* Ruby & Bundler

  Using rbenv:

  ```bash
  rbenv install $(cat .ruby-version)
  gem install bundler
  ```

* OS Dependencies

  Using brew:

  ```bash
  brew bundle
  ```
  **NOTE:** These will install the specified OS dependencies. If you do not use brew you need to install them manually.

* Bower

  ```bash
  npm install -g bower
  ```

## Setup

* Configure the projects ENV vars

  ```bash
  cp .env.example .env
  ```

  **NOTE:** We recommend using a shell environment switcher like [direnv](https://github.com/direnv/direnv) to manage the projects environment variables.

* Install dependencies and setup database

  ```bash
  bin/setup
  ```

* Install required fonts

  Double-click on each of the `app/assets/fonts/liberation_sans/*.ttf` files and Font Book will invite you to install them.
  
For local integration with SSO refer to [SSO Integration](docs/sso_integration.md)

[Assessment schema](docs/assessments_schema.md) has information that describes the configuration for the existent assessments that relate to a given PER.

# Running the application

  ```bash
  bundle exec rails s
  ```
  If you don't have a local MoJ SSO running & instead wish to mock SSO you can do so with the following:

  ```bash
  MOCK_SSO=true bundle exec rails s
  ```

  It is also possible to use the filesystem storage (instead of the default AWS S3) for the PER documents by running the server like the following:

  ```bash
  MOCK_AWS_S3=true bundle exec rails s
  ```

# Running tests

  ```bash
  bundle exec rspec
  ```

# Running cops

  ```bash
  bundle exec rubocop
  ```

# Deployment

## Development environment

Any deploys are automatically performed on master green builds.

## Staging environment

In [Jenkins](https://ci.service.dsd.io/view/MPS/job/mps-deploy/build)

```
APP_BUILD_TAG = BRANCH_NAME.latest
ENVIRONMENT = staging
```

## Production environment
In [Jenkins](https://ci.service.dsd.io/view/MPS/job/mps-build-docker/) > LAST_BUILD > Console Output

Find the 7 hex digit for SHORT_SHA

```shell
Pushing tag for rev [IMAGE_SHA] on {https://registry.service.dsd.io/v1/repositories/mps/tags/BRANCH_NAME.SHORT_SHA}
Pushing docker image registry.service.dsd.io/mps:BRANCH_NAME.latest
```

In [Jenkins](https://ci.service.dsd.io/view/MPS/job/mps-deploy/build)

```
APP_BUILD_TAG = master.SHORT_SHA
ENVIRONMENT = prod
```

**NOTE:** Requires appropriate permission to access

