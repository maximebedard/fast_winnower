module FastWinnower
  class Match
    attr_reader(
      :fingerprints_a,
      :fingerprints_b,
      :indexes_a,
      :indexes_b,
      :matching_fingerprints,
      :windows_a,
      :windows_b,
    )

    def initialize(windows_a, windows_b)
      @windows_a = windows_a
      @windows_b = windows_b
      @indexes_a, @fingerprints_a = windows_a.transpose
      @indexes_b, @fingerprints_b = windows_b.transpose
      @matching_fingerprints = build_matching_fingerprints
    end

    def reverse
      new(windows_b, windows_a)
    end

    protected

    def build_matching_fingerprints
      fingerprints_a & fingerprints_b
    end
  end
end
