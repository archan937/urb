# -*- encoding: utf-8 -*-
require File.expand_path("../lib/urb/version", __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Paul Engel"]
  gem.email         = ["pm_engel@icloud.com"]
  gem.summary       = %q{Shorten URLs in your Rack / Rails app}
  gem.description   = %q{Shorten URLs in your Rack / Rails app}
  gem.homepage      = "https://github.com/archan937/urb"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "urb"
  gem.require_paths = ["lib"]
  gem.version       = URB::VERSION

  gem.add_dependency "moneta"
  gem.add_development_dependency "rake"
  gem.add_development_dependency "pry"
end
