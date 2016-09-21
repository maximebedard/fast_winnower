module FastWinnower
  class Pair
    attr_reader(
      :compared,
      :fingerprints_compared,
      :fingerprints_reference,
      :indexes_compared,
      :indexes_reference,
      :reference,
      :windows_compared,
      :windows_reference,
    )

    def initialize(reference, compared)
      @reference = reference
      @compared = compared
      @windows_reference = reference.windows
      @windows_compared = compared.windows
      @indexes_reference, @fingerprints_reference = windows_reference.transpose
      @indexes_compared, @fingerprints_compared = windows_compared.transpose
    end

    def reverse
      new(b, a)
    end

    def similarities
      @similarities ||= SimilarityAllocator.allocate(self)
    end

    def intersecting_fingerprints
      fingerprints_reference & fingerprints_compared
    end

    def all_fingerprints
      fingerprints_reference | fingerprints_compared
    end

    def similarity_coefficient
      intersecting_fingerprints.size.to_f / all_fingerprints.size.to_f
    end
    alias_method :jaccard_coefficient, :similarity_coefficient
    alias_method :jaccard_distance, :similarity_coefficient
  end
end
