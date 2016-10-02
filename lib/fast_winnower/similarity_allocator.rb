module FastWinnower
  # If a1 in document 1 matches a2 in document 2, and b1
  # in document 1 matches b2 in document 2, and furthermore a1 and
  # b1 are consecutive in document 1 and a2 and b2 are consecutive in
  # document 2, then we have discovered a longer match across documents
  # consisting of a followed by b. While this merging of matches
  # is easy to implement, k-grams are naturally coarse and some of the
  # match is usually lost at the beginning and the end of the match.
  class SimilarityAllocator
    extend Forwardable

    def self.allocate(comparaison_result)
      new(comparaison_result).allocate
    end

    protected

    def allocate
      windows_a
        .each_with_index
        .inject([]) do |memo, window_a, i|
          similarities = similarities_for(window_a, i)
          memo + similarities
        end
    end

    def initialize(comparaison_result)
      @comparaison_result = comparaison_result
    end

    def_delegators(
      :@comparaison_result,
      :fingerprints_compared,
      :fingerprints_reference,
      :intersecting_fingerprints,
    )

    private

    def build_similarity(i, j)
      length = measure_length(i, j)

      index_a = windows_a[i][0]
      index_b = windows_b[j][0]

      Similarity.new(
        index_a..index_a + length,
        index_b..index_b + length,
      )
    end

    def similarities_for(window_a, i)
      windows_b
        .each_with_index
        .select { |window_b, _| window_a[1] == window_b[1] }
        .map { |_, j| build_similarity(i, j) }
    end

    def measure_length(i, j)
      length = 0
      length += 1 while consecutive?(i + length, j + length)
      length
    end

    def consecutive?(offset_a, offset_b)
      return false if offset_a >= windows_a.size
      return false if offset_b >= windows_b.size

      windows_a[offset_a][1] == windows_b[offset_b][1]
    end
  end
end
