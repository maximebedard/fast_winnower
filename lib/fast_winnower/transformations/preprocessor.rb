require "fast_winnower/preprocessors/null"

module FastWinnower
  module Transformations
    class Preprocessor
      ModeNotSupportedError = Class.new(StandardError)
      PreprocessorNotFoundError = Class.new(StandardError)

      def call(input = {})
        preprocessor = detect_preprocessor(input[:detection_mode], input[:path])

        input[:data] = preprocessor.call(input[:data])

        yield(input)
      end

      class << self
        attr_writer :detection_strategies, :preprocessors

        def detection_strategies
          @detection_strategies ||= default_detection_strategies
          yield @detection_strategies if block_given?
          @detection_strategies
        end

        def preprocessors
          @preprocessors ||= default_preprocessors
          yield @preprocessors if block_given?
          @preprocessors
        end

        private

        def default_detection_strategies
          {
            extension: -> (*args) { detect_by_extension(*args) },
            mime_type: -> (*args) { detect_by_mime_type(*args) },
            none: -> (*) { Null.new },
          }
        end

        def default_preprocessors
          require "fast_winnower/preprocessors/plain"
          require "fast_winnower/preprocessors/source"

          [
            Preprocessors::Plain,
            Preprocessors::Source,
          ]
        end

        def detect_by_extension(path)
          ext = File.extname(path)
          fallback = lambda do
            raise PreprocessorNotFoundError, "Preprocessor can't be found for extension #{ext}"
          end

          preprocessors.detect(fallback) do |p|
            p.supported_extensions.include?(ext)
          end.new
        end

        def detect_by_mime_type(*)
          raise NotImplementedError
        end
      end

      private

      def detect_preprocessor(mode, *args)
        strategy = self.class.detection_strategies.fetch(mode) do
          raise(ModeNotSupportedError, "#{mode} is not supported")
        end

        strategy.call(*args)
      end
    end
  end
end
