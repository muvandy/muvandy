# -*- encoding: utf-8 -*-
require File.expand_path('../lib/muvandy/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Aldwin Ibuna"]
  gem.email         = ["aibuna@gmail.com"]
  gem.description   = %q{Gem for Muvandy API}
  gem.summary       = %q{Gem for Muvandy API}
  gem.homepage      = "https://github.com/muvandy/muvandy"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "muvandy"
  gem.require_paths = ["lib"]
  gem.version       = Muvandy::VERSION
  gem.add_runtime_dependency(%q<httparty>, ["~> 0.8"])
end
