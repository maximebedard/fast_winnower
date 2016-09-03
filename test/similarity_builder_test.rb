require "test_helper"

class SimilarityBuilderTest < MiniTest::Test
  def test_idential_windows
    windows_a = [[0, "a"], [1, "b"], [2, "c"], [3, "d"]]
    windows_b = windows_a.dup

    expected = FastWinnower::Similarity.new(0..3, 0..3)
    actual = FastWinnower::SimilarityBuilder.new(windows_a, windows_b).call

    assert_equal [expected], actual
  end

  def test_shifted_windows
    windows_a = [[0, "z"], [1, "z"], [2, "z"], [3, "z"], [4, "a"], [5, "b"], [6, "c"], [7, "d"]]
    windows_b = [[0, "a"], [1, "b"], [2, "c"], [3, "d"]]

    expected = FastWinnower::Similarity.new(4..7, 0..3)
    actual = FastWinnower::SimilarityBuilder.new(windows_a, windows_b).call

    assert_equal [expected], actual
  end

  def test_reverse_shifted_windows
    windows_a = [[0, "a"], [1, "b"], [2, "c"], [3, "d"]]
    windows_b = [[0, "z"], [1, "z"], [2, "z"], [3, "z"], [4, "a"], [5, "b"], [6, "c"], [7, "d"]]

    expected = FastWinnower::Similarity.new(4..7, 0..3)
    actual = FastWinnower::SimilarityBuilder.new(windows_a, windows_b).call

    assert_equal [expected], actual
  end
end
