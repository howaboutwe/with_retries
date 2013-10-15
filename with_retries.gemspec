# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'with_retries/version'

Gem::Specification.new do |gem|
  gem.name          = "with_retries"
  gem.version       = WithRetries::VERSION
  gem.authors       = ["Bryan Woods", "Abel Martin", "George Ogata"]
  gem.email         = ["dev@howaboutwe.com"]
  gem.description   = %q{Adds a with_retries method to Kernel for retrying things}
  gem.summary       = %q{Maybe later}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.add_development_dependency 'rspec', '~> 2.14.1'
end
