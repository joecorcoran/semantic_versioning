require 'set'

module SemanticVersioning

  class VersionSet < SortedSet

    def initialize(versions)
      versions.map! { |v| Version.new(v) } if versions.all? { |v| v.is_a?(String) }
      super(versions)
    end

    def where(operator, version)
      version = Version.new(version) if version.is_a? String
      subset = select { |v| v.send(operator, version) }
      self.class.new(subset)
    end

  end

end