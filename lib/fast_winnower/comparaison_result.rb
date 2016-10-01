require "fast_winnower/comparator"
require "fast_winnower/similarity_allocator"

module FastWinnower
  class ComparaisonResult
    attr_reader(
      :comparator,
      :fingerprints_compared,
      :fingerprints_reference,
      :indexes_compared,
      :indexes_reference,
      :windows_compared,
      :windows_reference,
    )

    def initialize(windows_reference, windows_compared, comparator = Comparator.new)
      @windows_reference = windows_reference
      @windows_compared = windows_compared
      @comparator = comparator

      @indexes_reference, @fingerprints_reference = windows_reference.transpose
      @indexes_compared, @fingerprints_compared = windows_compared.transpose
    end

    def reverse
      new(windows_compared, windows_reference, comparator)
    end

    def similarities
      SimilarityAllocator.allocate(self)
    end

    def intersecting_fingerprints
      comparator.intersect(fingerprints_reference, fingerprints_compared)
    end

    def all_fingerprints
      comparator.all(fingerprints_reference, fingerprints_compared)
    end

    def similarity_coefficient
      intersecting_fingerprints.size.to_f / all_fingerprints.size
    end
    alias_method :jaccard_coefficient, :similarity_coefficient
    alias_method :jaccard_distance, :similarity_coefficient
  end

  class Comparator
    def intersect(a, b)
      a & b
    end

    def all(a, b)
      a | b
    end
  end
end
