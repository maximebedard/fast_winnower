module FastWinnower
  module Preprocessors
    class Plain
      def self.supported_extensions
        [".txt", ".md"]
      end

      def call(content)
        content
          .downcase
          .chars
          .each_with_index
          .select { |c, _| c =~ /\w/ }
      end
    end
  end
end
