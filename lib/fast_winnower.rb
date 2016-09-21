require "set"
require "digest"
require "fast_winnower/version"
require "fast_winnower/hashers/most_significant_sha1"
require "fast_winnower/preprocessors/plain"
require "fast_winnower/preprocessors/source"
require "fast_winnower/winnower"
require "fast_winnower/match"
require "fast_winnower/similarity_allocator"

module FastWinnower
  module Preprocessors
    extend self

  end

  def tokenize(*tokenizables, preprocessors: true)

  end

  def compare(*comparables, pair_klass: Pair)
    comparables
      .each_slice(2)
      .select { |args| args.size == 2 }
      .map { |args| pair_klass.new(*args) }
  end

  private

  def normalize_preprocessors(preprocessors)
    preprocessors = Array(preprocessors)
    preprocessors = preprocessors.size < 2 ? preprocessors * 2 : preprocessors.take(2)
    preprocessors
  end

  class TokenizedResult
    def initialize(content, preprocessor, **options)
      @content = File.file?(content) ? File.read(content) : content
      @preprocessor = preprocessor
      @winnower = options.fetch(:winnower, Winnower)
      @options = options
    end

    attr_reader :content

    def windows
      @windows ||= @winnower.new(tokens, @options)
    end

    def tokens
    end
  end
end
