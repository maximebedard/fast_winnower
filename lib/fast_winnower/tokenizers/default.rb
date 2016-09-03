module FastWinnower
  module Tokenizers
    class Default
      def self.call(value)
        value
          .chars
          .each_with_index
          .map { |c, i| [i, c.downcase] }
          .select { |_, c| c =~ /\w/ }
      end
    end
  end
end
