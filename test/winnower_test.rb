require "test_helper"
require "fast_winnower/transformations/winnower"

module WinnowerTests
  def test_call_with_tokens
    input = { data: [["h", 0], ["e", 1], ["l", 2], ["l", 3], ["o", 4]] }

    @strategy.call(input) do |actual|
      assert_equal(Set.new([[47312, 2]]), actual[:data])
    end
  end

  def test_call_returns_an_empty_set_when_nil
    @strategy.call do |actual|
      assert_equal(Set.new, actual[:data])
    end
  end

  def test_call_returns_an_empty_set_when_empty
    @strategy.call(data: []) do |actual|
      assert_equal(Set.new, actual[:data])
    end
  end

  # def test_call_returns_the_rightmost_hash
  #   windows = @strategy.from_string("A do run run run, a do run run").call
  #
  #   assert_equal(
  #     Set.new([[65233, 3], [64212, 7], [64212, 11], [34438, 14], [65233, 21], [64212, 25]]),
  #     windows,
  #   )
  # end
end

class WinnowerTest < Minitest::Test
  include WinnowerTests

  def setup
    @strategy = ::FastWinnower::Transformations::Winnower.new
  end
end

class FastWinnowerTest < Minitest::Test
  # include WinnowerTests
  # def setup
  #   @strategy = ::FastWinnower::FastWinnower.new
  # end
end
