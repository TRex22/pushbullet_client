# PushbulletClient
A client for the Pushbullet API. See: https://docs.pushbullet.com/v10/#quick-start

This is an unofficial project and still a work in progress (WIP) ... more to come soon.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pushbullet_client'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pushbullet_client

## Usage

```ruby
  require 'pushbullet'
  client = Pushbullet::Client.new(access_token: 'your access_token')

  # Some example calls
  client.devices

```

### Responses
Every call returns a hash with `body`, `headers`, `status` (HTTP code), `metadata` (including the
`cursor` for the next page) and `rate_limit`.

`rate_limit` is `{ 'limit', 'remaining', 'reset' }` parsed from the `X-Ratelimit-*` headers
(`reset` is Unix time in seconds; any value is `nil` if the header was not sent). Per the
[docs](https://docs.pushbullet.com/), a request costs 1 and each database operation (roughly each
object returned) costs 4, so a page of 250 pushes costs about 1001. Exceeding the limit returns
HTTP 429.

### Syncing cheaply
```ruby
  # Only pushes modified since your newest stored one: a handful of units, not a whole page
  client.pushes(modified_after: newest_modified)

  # Leave out deleted pushes
  client.pushes(active: true)
```

### Endpoints
  - Chats
  - Devices
  - Permanents
  - Pushes
  - Subscriptions
  - Texts
  - Users

### Constants
  Constants

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

### Tests
To run tests execute:

    $ rake test

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/trex22/pushbullet_client. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the pushbullet_client: project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/trex22/pushbullet_client/blob/master/CODE_OF_CONDUCT.md).
