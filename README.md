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

Version 0.2.0
    - replace head.js with yepnope.js for javascript loader
    - dynamically append path for sprockets for assets
    - adding path for images noted by grandslam
    - refactoring

Version 0.1.3
    - adds head, backbone, underscore js in assets pipeline
    - scaffolds capistrano deploy script

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
