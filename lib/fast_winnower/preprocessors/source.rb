module FastWinnower
  module Preprocessors
    class Source
      def self.supported_extensions
        []
      end

      def call(_content)
        raise NotImplementedError
      end
    end
  end
end
