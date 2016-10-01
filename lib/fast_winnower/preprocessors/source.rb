module FastWinnower
  module Preprocessors
    class Source
      def self.supported_extensions
        [".rb"]
      end

      def call(content)
        content.downcase
      end
    end
  end
end
