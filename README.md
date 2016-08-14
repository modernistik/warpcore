# WarpCore

WarpCore is a set of components and classes commonly used for quickly building scalable cloud applications with [Parse-Server](https://github.com/adelevie/parse-ruby-client) and Ruby. It bundles several technologies such as: [Puma](http://puma.io/), [Parse-Server REST Client](https://github.com/modernistik/parse-stack), [MongoDB](https://www.mongodb.com/), [Redis](http://redis.io/) and [Sidekiq](https://github.com/mperham/sidekiq).

### Code Status
[![Gem Version](https://badge.fury.io/rb/warpcore.svg)](https://badge.fury.io/rb/warpcore)
[![Build Status](https://travis-ci.org/modernistik/warpcore.svg?branch=master)](https://travis-ci.org/modernistik/warpcore)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'warpcore'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install warpcore

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).
