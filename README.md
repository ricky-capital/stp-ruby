# STP Ruby Library

Provides access to the STP web service from ruby applications.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'stp-ruby'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install stp-ruby

## Usage

### configuration

```ruby
Stp.configure do |config|
  # defaults to http://demo.stpmex.com:7004/speidemo/webservices/SpeiServices?WSDL
  config.wsdl = 'http://demo.stpmex.com:7004/speidemo/webservices/SpeiServices?WSDL'
  config.key_path = '/path/to/key.pem'
  config.key_passphrase = 'secret'
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ricky-capital/stp-ruby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Stp::Ruby project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/stp-ruby/blob/master/CODE_OF_CONDUCT.md).
