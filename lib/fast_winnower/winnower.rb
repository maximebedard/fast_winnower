module FastWinnower
  class Winnower
    def self.from_string(string, tokenizer: FastWinnower::Tokenizers::Ascii, **options)
      new(tokenizer.call(string), **options)
    end

    def initialize(tokens, window_size: 4, kgram_size: 3, hasher: FastWinnower::Hashers::SHA1)
      @tokens = Array(tokens)
      @window_size = window_size
      @kgram_size = kgram_size
      @hasher = hasher
    end

    def call
      fingerprints = build_fingerprints
      windows = build_windows(fingerprints)

      Set.new(windows)
    end

    private

    def build_fingerprints
      each_kgram(@tokens, @kgram_size)
        .map do |kgram|
          fingerprint(kgram)
        end
    end

    def build_windows(fingerprints)
      each_kgram(fingerprints, @window_size)
        .map do |kgram|
          kgram.min { |a, b| a[1] <=> b[1] }
        end
    end

    def fingerprint(kgram)
      indexes, tokens = kgram.transpose
      fingerprint = @hasher.call(tokens.join)
      [indexes[0], fingerprint]
    end

    def each_kgram(enumerable, n)
      return [] if enumerable.empty?
      return [enumerable] if enumerable.size < n
      enumerable.each_cons(n)
    end
  end
end
