# SemanticVersioning

Utility for working with software versions as specified by [Semantic Versioning 2.0.0-rc.1](http://semver.org).

[![Build status](https://travis-ci.org/joecorcoran/semantic_versioning.png?branch=master)](https://travis-ci.org/joecorcoran/semantic_versioning)

## SemanticVersioning::Version

Create a version object from a SemVer-formatted string.

```ruby
version = SemanticVersioning::Version.new('1.2.0-pre.1+b.42')
version.major
  # => 1
version.build
  # => "b.42"
```

Increment version identifiers.

```ruby
version.increment(:major)
version
  # => "2.0.0"
```

Compare versions.

```ruby
current = SemanticVersioning::Version.new('1.2.0-pre.1')
previous = SemanticVersioning::Version.new('1.1.12')
current > previous
  # => true
```

## SemanticVersioning::VersionSet

Work with sorted version sets.

```ruby
versions = SemanticVersioning::VersionSet.new(['1.2.0-pre.3', '1.3.0'])
  # => #<SemanticVersioning::VersionSet: {1.2.0-pre.3, 1.3.0}>
versions << SemanticVersioning::Version.new('1.1.12')
  # => #<SemanticVersioning::VersionSet: {1.1.12, 1.2.0-pre.3, 1.3.0}>
versions.where(:>=, '1.1.13')
  # => #<SemanticVersioning::VersionSet: {1.2.0-pre.3, 1.3.0}>
```

## License

Released under an MIT license (see LICENSE.txt).

http://blog.joecorcoran.co.uk