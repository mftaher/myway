# Use capybara to write application acceptance tests.
# This setup is for testing headless with phantomjs, call set_driver
# to use poltergeist, by default it uses selenium javascript driver

require_relative "spec_helper"
require "capybara"
require "capybara/dsl"
require "capybara/rspec"
require "capybara/poltergeist"

def app
  Rack::Builder.parse_file(File.expand_path(File.join(File.dirname(__FILE__), "../", "/config.ru")))
end

RSpec.configure do |config|
  config.include Capybara::DSL
  Capybara.app, _ = app
end

def set_driver(debug=false)
  Capybara.javascript_driver = :poltergeist
  if debug
    Capybara.register_driver :poltergeist do |app|
      Capybara::Poltergeist::Driver.new(app, {:inspector=>true, :debug => true})
    end
  end
end


# Uncomment the following line if you want to use poltergeist driver
# set_driver