# Myway

My way was popular frank sinatra song during 1969 and was top on billboard chart during that time. Now myway here
provides basic sinatra scaffolding project for everyone to use. It comes with capistrano and unicorn integrated. By
default the sinatra app uses haml as it's templating engine.

## Installation and Usage

Install it yourself from source:

    $ rake install


Or,

Install from rubygems

    $ gem install myway

And then execute:

    $ mw

And to start a new sinatra project:

    $ mw new "YourProjectName"


CHANGE LOG

VERSION 0.1.3
    - adds head, backbone, underscore js in assets pipeline
    - scaffolds capistrano deploy script

VERSION 0.1.5
    - optional capybara and jasmine test setup


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
