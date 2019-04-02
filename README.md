# README

## Overview

Budgeting Application that uses Plaid to connect to your bank accounts and get real-time balances to enable better budgeting and monitoring.

## Setup

### Environment Requirements
* Ruby 2.3.1
* Rails 5.1.7
* PostgreSQL 10.3
```
git clone https://github.com/kateugenio/bucket_list.git
cd budgetbucket
bundle install
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