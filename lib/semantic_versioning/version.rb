module SemanticVersioning
  class Version

    include Comparable

    PATTERN = /^
      (?<req>
        (?<major>[0-9]+)\.
        (?<minor>[0-9]+)\.
        (?<patch>[0-9]+)
      )
      (-(?<pre>[0-9A-Za-z\-\.]+))?
      (\+(?<build>[0-9A-Za-z\-\.]+))?
    $/x

    attr_reader :major, :minor, :patch, :req, :pre, :build, :segments

    def initialize(input, segment = Segment, segments = Struct.new(:req, :pre, :build))
      if (m = input.match(PATTERN))
        @input = input
        @major, @minor, @patch = m['major'].to_i, m['minor'].to_i, m['patch'].to_i
        @req, @pre, @build = m['req'], m['pre'], m['build']
        @segments = segments.new(
          segment.new(@req),
          segment.new(@pre),
          segment.new(@build)
        )
      else
        raise VersionError, 'input was not formatted correctly'
      end
    end

    def <=>(other)
      return nil unless other.is_a?(Version)
      return 0 if to_s == other.to_s
      if req == other.req
        return -1 if pre && other.pre.nil?
        return 1 if pre.nil? && other.pre
      end
      scores = [
        segments.req   <=> other.segments.req,
        segments.pre   <=> other.segments.pre,
        segments.build <=> other.segments.build
      ]
      scores.compact.detect { |s| s.abs == 1 }
    end

    def to_s
      @input
    end

  end

  class Segment

    include Comparable

    def initialize(input)
      @input = input
    end

    def identifiers
      return [] if @input.nil?
      ids = @input.split('.')
      ids.map! { |id| id.match(/^[0-9]+$/) ? id.to_i : id }
    end

    def <=>(other)
      return nil unless other.is_a?(Segment)
      scores = scores_vs(other)
      scores.compact.detect { |s| s.abs == 1 }
    end

    private

      def scores_vs(other)
        ids = { :self => identifiers, :other => other.identifiers }
        padded_ids, scores = pad_ids(ids), []
        padded_ids[:self].each_with_index do |id, idx|
          scores << (id <=> padded_ids[:other][idx])
        end
        scores
      end

      def pad_ids(id_arrays)
        sorted = id_arrays.sort { |a, b| b[1].length <=> a[1].length  }
        str, int = '', 0
        sorted[0][1].each_with_index do |id, idx|
          if idx >= sorted[1][1].length
            sorted[1][1] << (id.is_a?(Integer) ? int : str)
          end
        end
        Hash[sorted]
      end

  end

  class VersionError < ArgumentError; end
end