# -*- encoding: utf-8 -*-
require File.expand_path('../lib/vintner/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["JH. Chabran"]
  gem.email         = ["jh@chabran.fr"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "vintner"
  gem.require_paths = ["lib"]
  gem.version       = Vintner::VERSION

  gem.add_dependency 'active_support'
  gem.add_dependency 'i18n'
  gem.add_development_dependency 'rspec', '~> 2.6'
end