require "test_helper"

class PreprocessorsTest < MiniTest::Test
  def test_can_be_preprocessed
    assert_equal true, FastWinnower::Preprocessors.can_be_preprocessed?("./test.md")
  end

  def test_cant_be_preprocessed
    assert_equal false, FastWinnower::Preprocessors.can_be_preprocessed?("./test.rb")
  end

  def test_for_filepath_can_be_preprocessed
    preprocessor = FastWinnower::Preprocessors.for_filepath("./test.md")

    assert_equal FastWinnower::Preprocessors::Plain, preprocessor
  end

  def test_for_filepath_cant_be_preprocessed
    preprocessor = FastWinnower::Preprocessors.for_filepath("./test.rb")

    assert_nil preprocessor
  end
end
