require "test_helper"

module WinnowerTests
  def test_call_with_tokens
    windows = @strategy.new(
      [[0, "h"], [1, "e"], [2, "l"], [3, "l"], [4, "o"]],
    ).call

    assert_equal(Set.new([[0, 17229]]), windows)
  end

  def test_call_with_string
    windows = @strategy.from_string("hello").call

    assert_equal(Set.new([[0, 17229]]), windows)
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

    assert_equal(Set.new([]), windows)
  end

  def test_call_minimize_repetition
    windows = @strategy.from_string("A do run run run, a do run run").call

    assert_equal(Set.new([[2, 1966], [5, 23942], [9, 23942], [14, 2887], [20, 1966]]), windows)
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
