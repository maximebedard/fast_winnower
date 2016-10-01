require "fast_winnower/hashers/most_significant_sha1"

module FastWinnower
  module Transformations
    class Winnower
      def initialize(window_size: 4, kgram_size: 3, hasher: FastWinnower::Hashers::MostSignificantSHA1)
        @window_size = window_size
        @kgram_size = kgram_size
        @hasher = hasher
      end

      def call(input = {})
        tokens = Array(input[:data])

        fingerprints = build_fingerprints(tokens)
        windows = build_windows(fingerprints)

        input[:data] = Set.new(windows)

        yield(input)
      end

      private

      def build_fingerprints(tokens)
        each_kgram(tokens, @kgram_size)
          .map do |kgram|
            fingerprint(kgram)
          end
      end

      def build_windows(fingerprints)
        each_kgram(fingerprints, @window_size)
          .map do |kgram|
            kgram.max { |a, b| a[0] <=> b[0] }
          end
      end

      def fingerprint(kgram)
        tokens, indexes = kgram.transpose
        fingerprint = @hasher.call(tokens.join)
        [fingerprint, indexes[0]]
      end

      def each_kgram(enumerable, n)
        return [] if enumerable.empty?
        return [enumerable] if enumerable.size < n
        enumerable.each_cons(n)
      end
    end
  end
end
