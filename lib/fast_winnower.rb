require "set"
require "digest"
require "fast_winnower/version"
require "fast_winnower/middleware"
require "fast_winnower/comparaison_result"

module FastWinnower
  extend self

  def middleware
    @middleware ||= default_middlewares
    yield @middleware if block_given?
    @middleware
  end

  def preprocess(input, *args, &block)
    input = normalize_input_hash(input, *args)

    middleware.invoke(input, &block)
  end

  def compare(*args)
    ComparaisonResult.new(*args)
  end

  private

  def normalize_input_hash(input, **opts)
    ret = opts.dup
    ret[:data] = input
    ret[:detection_mode] = :none

    if File.file?(input)
      ret[:data] = input.read
      ret[:path] = input.path
      ret[:detection_mode] ||= :extension
    end

    ret
  end

  def default_middlewares
    require "fast_winnower/middlewares/preprocessor"
    require "fast_winnower/middlewares/tokenizer"
    require "fast_winnower/middlewares/winnower"

    MiddlewareChain.new do |m|
      m.add(Middlewares::Preprocessor, preprocessors: default_preprocessors)
      m.add(Middlewares::Tokenizer)
      m.add(Middlewares::Winnower)
    end
  end

  def default_preprocessors
    require "fast_winnower/preprocessors/plain"
    require "fast_winnower/preprocessors/source"

    [
      Preprocessors::Plain.new,
      Preprocessors::Source.new,
    ]
  end
end
