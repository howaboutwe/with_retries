# with_retries

## Installation

Add this line to your application's Gemfile:

    gem 'with_retries'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install with_retries

## Usage

```ruby
# example.rb
require 'with_retries'

Boom = Class.new(RuntimeError)

with_retries(Boom, attempts: 3) do
  puts "Here I am"
  raise Boom.new("BOOM!")
end

#=> $ ruby example.rb
#=> Here I am
#=> Here I am
#=> Here I am
#=> example.rb:8:in `block in <main>': BOOM! (Boom)
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
