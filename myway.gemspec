# -*- encoding: utf-8 -*-
require File.expand_path('../lib/myway/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Fazle Taher"]
  gem.email         = ["ftaher@gmail.com"]
  gem.description   = %q{Sinatra project generator for sinatra based web applications. Named after
                        Frank Sinatra's popular song during 1969 'My way'}
  gem.summary       = %q{Scaffolding application for Sinatra web projects}
  gem.homepage      = "http://github.com/mftaher/myway"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "myway"
  gem.require_paths = ["lib"]
  gem.version       = Myway::VERSION
  gem.add_runtime_dependency "thor", ">= 0.15.2"
end
