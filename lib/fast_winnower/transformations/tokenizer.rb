module FastWinnower
  module Transformations
    class Tokenizer
      def call(input = {})
        input[:data] = input[:data]
          .to_s
          .chars
          .each_with_index
          # .select { |c, _| c =~ /\w/ }

        yield(input)
      end
    end
  end
end
