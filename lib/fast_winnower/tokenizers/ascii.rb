module FastWinnower
  module Tokenizers
    module Ascii
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
