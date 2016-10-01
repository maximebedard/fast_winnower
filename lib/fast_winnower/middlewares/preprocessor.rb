module FastWinnower
  module Middlewares
    class Preprocessor
      ModeNotSupportedError = Class.new(StandardError)
      PreprocessorNotFoundError = Class.new(StandardError)

      attr_reader(
        :preprocessors,
        :detection_strategies,
      )

      NULL_PREPROCESSOR = -> (data) { data }
      DEFAULT_DETECTION_STRATEGIES = {
        extension: -> (*args) { detect_by_extension(*args) }
        mime_type: -> (*args) { detect_by_mime_type(*args) }
        none: -> (*) { NULL_PREPROCESSOR }
      }

      def initialize(**options)
        @preprocessors = Array(options[:preprocessors])
        @detection_strategies = options[:detection_strategies]
        @detection_strategies ||= DEFAULT_DETECTION_STRATEGIES
      end

      def call(input = {})
        preprocessor = detect_preprocessor(input[:detection_mode], input[:path])

        input[:data] = preprocessor.call(input[:data])

        yield(input)
      end

      private

      def detect_preprocessor(mode, *args)
        strategy = detection_strategies.fetch(mode) { raise(ModeNotSupportedError, "#{mode} is not supported") }
        strategy.call(*args)
      end

      def detect_by_extension(path)
        ext = File.extname(path)
        fallback = lambda do
          raise PreprocessorNotFoundError, "Preprocessor can't be found for extension #{ext}"
        end

        preprocessor.detect(fallback) do |p|
          p.supported_extensions.include?(ext)
        end.new
      end

      def detect_by_mime_type(path)
        raise NotImplementedError
      end
    end
  end
end
