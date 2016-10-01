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

      @fingerprints_reference, @indexes_reference  = windows_reference.transpose
      @fingerprints_compared, @indexes_compared  = windows_compared.transpose

      @fingerprints_reference ||= []
      @fingerprints_compared ||= []
    end

    def reverse
      self.class.new(windows_compared, windows_reference, comparator)
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
      return 1 if all_fingerprints.size == 0

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
