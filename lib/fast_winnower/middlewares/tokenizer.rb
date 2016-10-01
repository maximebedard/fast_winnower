module FastWinnower
  module Middlewares
    class Tokenizer
      def call(input = {})
        input[:data] = input[:data]
          .chars
          .each_with_index
          .select { |c, _| c =~ /\w/ }

        yield(input)
      end
    end
  end
end
