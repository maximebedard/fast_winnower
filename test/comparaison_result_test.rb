require "test_helper"

class ComparaisonResultTest < MiniTest::Test
  class CustomComparator
    def intersect(*)
      [1234]
    end

    def all(*)
      [4321]
    end
  end

  def setup
    @reference = [[1234, 0], [5678, 1], [1111, 2]]
    @compared = [[1234, 0], [5678, 1], [2222, 2]]
    @result = FastWinnower::ComparaisonResult.new(@reference, @compared)
  end

  def test_reverse
    reversed = @result.reverse

    assert_equal @reference, reversed.windows_compared
    assert_equal @compared, reversed.windows_reference
  end

  def test_similarities
    # TODO add expectation here!
  end

  def test_intersecting_fingerprints
    assert_equal(
      [1234, 5678],
      @result.intersecting_fingerprints,
    )
  end

  def test_intersecting_fingerprints_with_custom_comparator
    @result = FastWinnower::ComparaisonResult.new(@reference, @compared, CustomComparator.new)

    assert_equal [1234], @result.intersecting_fingerprints
  end

  def test_all_fingerprints
    assert_equal(
      [1234, 5678, 1111, 2222],
      @result.all_fingerprints,
    )
  end

  def test_all_fingerprints_with_custom_comparator
    @result = FastWinnower::ComparaisonResult.new(@reference, @compared, CustomComparator.new)

    assert_equal [4321], @result.all_fingerprints
  end

  def test_similarity_coefficient
    assert_in_delta @result.similarity_coefficient, 0.01, 0.5
  end

  def test_similarity_coefficient_with_empty_windows
    @result = FastWinnower::ComparaisonResult.new([], [])
    assert_equal 1, @result.similarity_coefficient
  end

  def test_similarity_coefficient_with_almost_empty_windows
    @result = FastWinnower::ComparaisonResult.new([[]], [[]])
    assert_equal 1, @result.similarity_coefficient
  end
end
