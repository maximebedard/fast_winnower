require "test_helper"

class Features < MiniTest::TestCase
  def test_analyse_identical_content
    result = analyze("Hello world!", "Hello world!")

    expected = [Similarity.new(0..12, 0..12)]

    assert_equal expected, result.allocate
  end

  def test_analyse_shifted_content
    result = analyse("My name is Maxime, hello world!", "Hello world!")

    expected = [Similarity.new(0..12, 0..12)]

    assert_equal expected, result.allocate
  end

  private

  def similarities(a, b)
    windows_a = FastWinnower::Winnower.from_string(a)
    windows_b = FastWinnower::Winnower.from_string(b)

    FastWinnower::SimilarityAllocator.from_windows(windows_a, windows_b)
  end
end
