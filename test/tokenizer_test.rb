require "test_helper"
require "fast_winnower/transformations/tokenizer"

class TokenizerTest < MiniTest::Test
  def setup
    @tokenizer = FastWinnower::Transformations::Tokenizer.new
  end

  def test_call_returns_a_list_of_tuples
    @tokenizer.call(data: "hello") do |actual|
      assert_equal [["h", 0], ["e", 1], ["l", 2], ["l", 3], ["o", 4]], actual[:data].to_a
    end
  end

  def test_call_returns_an_empty_array
    @tokenizer.call(data: "") do |actual|
      assert_equal [], actual[:data].to_a
    end
  end

  def test_call_returns_an_empty_array_on_nil_value
    @tokenizer.call do |actual|
      assert_equal [], actual[:data].to_a
    end
  end
end
