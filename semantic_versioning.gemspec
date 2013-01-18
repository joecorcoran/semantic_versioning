# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'semantic_versioning/gem_version'

Gem::Specification.new do |gem|
  gem.name          = "semantic_versioning"
  gem.version       = SemanticVersioning::GEM_VERSION
  gem.authors       = ["Joe Corcoran"]
  gem.email         = ["joecorcoran@gmail.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.test_files    = gem.files.grep(%r{^spec/})
  gem.require_paths = ['lib']

  gem.add_development_dependency 'rspec', '~> 2.12.0'
end