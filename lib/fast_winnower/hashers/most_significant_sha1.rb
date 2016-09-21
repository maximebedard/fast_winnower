module FastWinnower
  module Hashers
    class MostSignificantSHA1
      def self.call(value)
        Digest::SHA1.hexdigest(value)[-4..-1].to_i(16)
      end
    end
  end
end
