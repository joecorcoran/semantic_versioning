# -*- encoding: utf-8 -*-
require File.expand_path('../lib/semantic_versioning/gem_version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = 'semantic_versioning'
  gem.version       = SemanticVersioning::GEM_VERSION
  gem.authors       = ['Joe Corcoran']
  gem.email         = ['joecorcoran@gmail.com']
  gem.description   = %q{A utility for working with software version numbers as specified by Semantic Versioning (http://semver.org/)}
  gem.summary       = %q{Ruby classes to represent versions and sorted sets of versions. No funny business. Updated as the SemVer spec develops.}
  gem.homepage      = 'http://github.com/joecorcoran/semantic_versioning'

  gem.files         = Dir.glob('lib/**/*')
  gem.test_files    = Dir.glob('spec/**/*')
  gem.require_paths = ['lib']

  gem.add_development_dependency 'rspec', '~> 2.12.0'
end