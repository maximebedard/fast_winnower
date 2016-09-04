require "test_helper"

module WinnowerTests
  def test_call_with_tokens
    windows = @strategy.new(
      [["h", 0], ["e", 1], ["l", 2], ["l", 3], ["o", 4]],
    ).call

    assert_equal(Set.new([[47312, 2]]), windows)
  end

  def test_call_with_string
    windows = @strategy.from_string("hello").call

    assert_equal(Set.new([[47312, 2]]), windows)
  end

  def test_call_returns_an_empty_set_when_nil
    windows = @strategy.new(nil).call

    assert_equal(Set.new, windows)
  end

  def test_call_returns_an_empty_set_when_empty
    windows = @strategy.new([]).call

    assert_equal(Set.new, windows)
  end

  def test_call_returns_the_rightmost_hash
    windows = @strategy.from_string("A do run run run, a do run run").call

    assert_equal(
      Set.new([[65233, 3], [64212, 7], [64212, 11], [34438, 14], [65233, 21], [64212, 25]]),
      windows,
    )
  end
end

class WinnowerTest < Minitest::Test
  include WinnowerTests

  def setup
    @strategy = ::FastWinnower::Winnower
  end
end

class FastWinnowerTest < Minitest::Test
  # include WinnowerTests
  # def setup
  #   @strategy = ::FastWinnower::FastWinnower
  # end
end
