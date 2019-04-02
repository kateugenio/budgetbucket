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