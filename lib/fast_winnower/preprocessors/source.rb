module FastWinnower
  module Preprocessors
    class Source
      def call(_content)
        raise NotImplementedError
      end
    end
  end
end
