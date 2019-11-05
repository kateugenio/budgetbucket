# README

## Overview

Budgeting Application that uses Plaid to connect to your bank accounts and get real-time balances to enable better budgeting and monitoring.

## Setup

### Environment Requirements
* Ruby 2.4.0
* Rails 5.2.3
* PostgreSQL 10.3
```
git clone https://github.com/kateugenio/bucket_list.git
cd budgetbucket
bundle install
```

## Credentials
Secrets are encrypted in credentials.yml.enc.

Master key is kept by repo owner. Place the key under config/ in a new file called master.key. You will need this key to run the server locally, setup the database, and to run tests.

To edit secrets:
```
EDITOR=vim rails credentials:edit
```

## Database setup

```
bundle exec rails db:setup
```

## Development

### Run Tests with Rubocop and Brakeman
```
bundle exec rake spec
```

### Code Analysis
[Brakeman](https://github.com/presidentbeef/brakeman) and [Rubocop](https://github.com/bbatsov/rubocop) are configured to run automatically whenever tests are run. To run them independently:

```
# security analysis: this will provide additional detail
bundle exec brakeman

# style analysis
bundle exec rubocop
```

To start the local server:
```
bundle exec rails s
```
From your browser, head to localhost:3000