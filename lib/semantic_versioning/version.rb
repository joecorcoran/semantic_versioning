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

    attr_reader :major, :minor, :patch, :required, :pre, :build, :segments

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
      @input
    end

  end

end