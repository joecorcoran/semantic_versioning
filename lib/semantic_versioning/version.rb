module SemanticVersioning
  
  class Version

    include Comparable

    PATTERN = /^
      (?<required>
        (?<major>[0-9]+)\.
        (?<minor>[0-9]+)\.
        (?<patch>[0-9]+)
      )
      (-(?<pre>[0-9A-Za-z\-\.]+))?
      (\+(?<build>[0-9A-Za-z\-\.]+))?
    $/x

    attr_reader :major, :minor, :patch, :required, :segments
    attr_accessor :pre, :build
    alias_method :prerelease, :pre

    def initialize(input, segment = Segment)
      if (m = input.match(PATTERN))
        @input = input
        @major, @minor, @patch = m['major'].to_i, m['minor'].to_i, m['patch'].to_i
        @required, @pre, @build = m['required'], m['pre'], m['build']
        @segments = [
          segment.new(@required),
          segment.new(@pre),
          segment.new(@build)
        ]
      else
        raise ParsingError, 'String input not correctly formatted for Semantic Versioning'
      end
    end

    def <=>(other)
      return nil unless other.is_a?(Version)
      return 0 if to_s == other.to_s
      if required == other.required
        return -1 if pre && other.pre.nil?
        return 1 if pre.nil? && other.pre
      end
      scores = segments.map.with_index { |s, idx| s <=> other.segments[idx] }
      scores.compact.detect { |s| s.abs == 1 }
    end

    def to_s
      version = "#{@major}.#{@minor}.#{@patch}"
      version += "-#{@pre}" unless pre.nil?
      version += "+#{@build}" unless build.nil?
      version
    end

    def increment(identifier)
      case identifier
      when :major
        @major += 1
        reset(:minor, :patch)
      when :minor
        @minor += 1
        reset(:patch)
      when :patch
        @patch += 1
      else
        raise IncrementError, 'Only :major, :minor and :patch attributes may be incremented'
      end
      clear_optional_identifiers
    end

    private

      def reset(*identifiers)
        identifiers.each do |id|
          instance_variable_set(:"@#{id}", 0)
        end
      end

      def clear_optional_identifiers
        @pre, @build = nil, nil
      end

  end

end