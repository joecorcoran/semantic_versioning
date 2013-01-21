module SemanticVersioning

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
        ids  = { :self => identifiers, :other => other.identifiers }
        pids = pad_ids(ids)
        pids[:self].map.with_index { |id, idx| id <=> pids[:other][idx] }
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

end