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

### Configuration

```ruby
# config/initializers/stp.rb

Stp.configure do |config|
  # defaults to http://demo.stpmex.com:7004/speidemo/webservices/SpeiServices?WSDL
  config.wsdl = 'http://demo.stpmex.com:7004/speidemo/webservices/SpeiServices?WSDL'
  config.key_path = '/path/to/key.pem'
  config.key_passphrase = 'secret'
end
```

### Webhooks

#### Routes

Mount the STP engine

```ruby
# config/routes.rb
mount Stp::Engine, at: '/stp', as: 'stp'
```

#### Subscribing with blocks

Subscribe to the events from your application:

```ruby
Stp.subscribe(Stp::Abono::EVENT_NAME) do |abono|
  # Do something with abono object
  # abono
  # => #<Stp::Abono:0x007f8985c453e0
  #       @clave="1101", @fecha_operacion="20100323", @institucion_ordenante="846",
  #       @institucion_beneficiaria="90646", @clave_rastreo="GEM801", @monto=200.0,
  #       @nombre_beneficiario="alfredo", @tipo_cuenta_beneficiario="40",
  #       @cuenta_beneficiario="110180077000000018", @rfc_curp_beneficiario="RFCBEN", @tipo_pago="7",
  #       @tipo_operacion="4", @concepto_pago="prueba", @referencia_numerica="2", @empresa="STP">
end
```

```ruby
Stp.subscribe(Stp::Estado::EVENT_NAME) do |estado|
  # Do something with estado object
  # estado
  # => #<Stp::Estado:0x007f8985bdeca8
  #       @id="3668949", @empresa="prueba", @estado="Éxito">
end
```

```ruby
Stp.subscribe(Stp::Devolucion::EVENT_NAME) do |devolucion|
  # Do something with devolucion object
  # devolucion
  # => #<Stp::Devolucion: A solicitud del emisor
  #       @message="A solicitud del emisor" @id="3668949" @resource_class=Stp::Estado>
end
```

#### Subscribing with objects

You can also pass an object that responds to `call` instead of a block

```ruby
class AbonoObserver
  def call(abono)
    # Do something with abono object
  end
end

Stp.subscribe(Stp::Abono::EVENT_NAME, AbonoObserver.new)
```

#### Without Rails

You can also use this library outside of a Rails app. Just implement your own endpoint and instrument the event. Here's an using Sinatra:

```ruby
require 'sinatra'
require 'stp'

Stp.subscribe(Stp::Abono::EVENT_NAME) do |abono|
  # Do something with abono object
end

post '/stp/abono' do
  Stp.instrument(Stp::Abono::EVENT_NAME, resource: Stp::Abono.new(request.body.read))
  200
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
