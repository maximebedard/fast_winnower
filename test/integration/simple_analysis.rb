require "test_helper"

class Integration::SimpleAnalysis < MiniTest::Test
  # def test_identical_content
  #   results = compare("hello world!", "hello world!")
  #
  #   assert_equal results, results
  # end

  private

  def compare(a, b)
    windows_a = FastWinnower::Winnower.from_string(a)
    windows_b = FastWinnower::Winnower.from_string(b)

    FastWinnower::Visualizer.new(
      Match.new(windows_a, windows_b),
    ).call
  end
end
