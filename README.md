# MyWay

MyWay was popular frank sinatra song during 1969 and was top on billboard chart during that time. Now MyWay
provides basic Sinatra project for everyone to use. It comes with capistrano and unicorn integrated. By
default the sinatra app uses haml as it's templating engine.

MyWay is integrated with Twitter-Bootstrap, every time you generate a new project with MyWay it gets the latest
Twitter-Bootstrap source and integrates with your project, making it ready state with Twitter-Bootstrap design.

As for javascript loader MyWay uses latest 'yepnope.js', an asynchronous conditional loader for your javascript/css to
manage dependencies or loading the scripts you need super fast!

Feel free to fork the project to generate your own Sinatra structure or add more bootstrap plugins, or contribute
enhancing this by sending pull request.

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
