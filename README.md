# Moving People Safely

[![CircleCI](https://circleci.com/gh/ministryofjustice/moving-people-safely.svg?style=svg)](https://circleci.com/gh/ministryofjustice/moving-people-safely) [![Code Climate](https://codeclimate.com/github/ministryofjustice/moving-people-safely/badges/gpa.svg)](https://codeclimate.com/github/ministryofjustice/moving-people-safely) [![Test Coverage](https://codeclimate.com/github/ministryofjustice/moving-people-safely/badges/coverage.svg)](https://codeclimate.com/github/ministryofjustice/moving-people-safely/coverage)

# Instalation

**NOTE:** These steps assume the comands are being run from the root of the project.

## Requirements

* Ruby & Bundler

  Using rbenv:

  ```bash
  rbenv install $(cat .ruby-version)
  gem install bundler
  ```

* Bower

  Using brew:

  ```bash
  brew install node
  npm install -g bower
  ```

* Postgres

  Using brew:

  ```bash
  brew install postgresql
  ```

## Setup

* Install dependencies and setup database

  ```bash
  bundle exec bin/setup
  ```

* Seeding data for **development** environment **only**

   ```bash
   bundle exec rake dev:moves
   ```

* Configure the projects ENV vars

  ```bash
  cp .env.example .env
  ```

We recommend using a shell environment switcher like [direnv](https://github.com/direnv/direnv) to manage the projects
environment variables.

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

# Running tests

  ```bash
  bundle exec rspec
  ```

# Running cops

  ```bash
  bundle exec rubocop
  ```

# Deployment

## Staging

Any deploys are automatically performed on master green builds.

## Production

In [Jenkins](https://ci.service.dsd.io/view/MPS/) > `mps-deploy` > Build with Parameters

**NOTE:** Requires appropriate permission to access
