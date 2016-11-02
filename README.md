# Moving People Safely

[![CircleCI](https://circleci.com/gh/ministryofjustice/moving-people-safely.svg?style=svg)](https://circleci.com/gh/ministryofjustice/moving-people-safely)

[![Code Climate](https://codeclimate.com/github/ministryofjustice/moving-people-safely/badges/gpa.svg)](https://codeclimate.com/github/ministryofjustice/moving-people-safely)

[![Test Coverage](https://codeclimate.com/github/ministryofjustice/moving-people-safely/badges/coverage.svg)](https://codeclimate.com/github/ministryofjustice/moving-people-safely/coverage)

# Instalation

**NOTE:** These steps assume the comands are being run from the root of the project.

## Requirements

* Ruby & Bundler

  Using rbenv:
  
  ```bash
  rbenv install $(cat .ruby-version)
  gem install bundler
  ```

* Postgres

  Using brew:

  ```bash
  brew install postgresql
  ```
  
## Setup

* Install dependencies by running `bundle`

* Setup database

  ```bash
  bundle exec rake db:setup
  ```

* Seeding data for **development** environment **only**

   ```bash
   bundle exec rake dev:prime
   bundle exec rake dev:moves
   ```
   
# Running the application

  ```bash
  bundle exec rails s
  ```
  
# Running tests

  ```bash
  bundle exec rspec
  ```
# Deployment

  TBD
