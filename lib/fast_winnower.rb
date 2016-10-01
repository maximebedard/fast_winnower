require "set"
require "digest"
require "fast_winnower/version"
require "fast_winnower/transformation_chain"
require "fast_winnower/comparaison_result"

module FastWinnower
  extend self

  def transformation_chain
    @transformation ||= default_transformations
    yield @transformation if block_given?
    @transformation
  end

  def preprocess(input, &block)
    input = normalize_input_hash(input)

    transformation.invoke(input, &block)
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

  def default_transformations
    require "fast_winnower/transformations/preprocessor"
    require "fast_winnower/transformations/tokenizer"
    require "fast_winnower/transformations/winnower"

    TransformationChain.new do |m|
      m.add(Transformations::Preprocessor, preprocessors: default_preprocessors)
      m.add(Transformations::Tokenizer)
      m.add(Transformations::Winnower)
    end
  end

  def default_preprocessors
  end
end
