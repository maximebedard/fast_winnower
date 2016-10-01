module FastWinnower
  module Preprocessors
    class Plain
      def self.supported_extensions
        [".txt", ".md"]
      end

      def call(content)
        content.downcase
      end
    end
  end
end
