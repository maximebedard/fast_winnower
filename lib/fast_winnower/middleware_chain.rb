module FastWinnower
  class MiddlewareChain
    include Enumerable

    attr_reader :entries

    def initialize
      @entries = [].to_set
      yield self if block_given?
    end

    def each(&block)
      entries.each(&block)
    end

    def add(klass, *args)
      entries << Entry.new(klass, *args)
    end

    def invoke(*args, &block)
      chain = retreive.dup

      traverse_chain = lambda do
        result =
          if chain.empty?
            yield
          else
            chain.shift.call(*args, &traverse_chain)
          end

        block.call(&block)
      end.call
    end

    private

    def retreive
      map(&:make_new)
    end

    class Entry
      def initialize(klass, *args)
        @klass = klass
        @args = args
      end

      def make_new
        @klass.new(*args)
      end
    end
  end
end
