# -*- encoding: utf-8 -*-
require File.expand_path('../lib/muvandy/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Aldwin Ibuna"]
  gem.email         = ["aibuna@gmail.com"]
  gem.description   = %q{Client for Muvandy API}
  gem.summary       = %q{Client for Muvandy API}
  gem.homepage      = "https://github.com/muvandy/muvandy"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "muvandy"
  gem.require_paths = ["lib"]
  gem.add_runtime_dependency(%q<httparty>, ["~> 0.8"])
  gem.add_runtime_dependency(%q<versionomy>, ["~> 0.4.3"])
  gem.version       = Muvandy::VERSION  
  
  gem.platform    = Gem::Platform::RUBY
  gem.rubyforge_project = 'muvandy'
end
