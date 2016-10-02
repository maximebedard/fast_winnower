require "test_helper"
require "fast_winnower/transformations/preprocessor"

class PreprocessorTest < MiniTest::Test
  class MockPreprocessor
    def self.supported_extensions
      [".md"]
    end

    def call(content)
      content
    end
  end

  def setup
    FastWinnower::Transformations::Preprocessor.preprocessors = [MockPreprocessor]

    @preprocessor = FastWinnower::Transformations::Preprocessor.new
    @file = Tempfile.new(["test", ".md"])
  end

  def test_detect_by_mime_type_raises
    assert_raises(NotImplementedError) do
      @preprocessor.call(detection_mode: :mime_type) {}
    end
  end

  def test_detect_by_unknow_mode_raises
    assert_raises(FastWinnower::Transformations::Preprocessor::ModeNotSupportedError) do
      @preprocessor.call(detection_mode: :yolo) {}
    end
  end

  def test_detect_by_nil_mode_raises
    assert_raises(FastWinnower::Transformations::Preprocessor::ModeNotSupportedError) do
      @preprocessor.call {}
    end
  end

  def test_detect_by_extension_with_unsupported_extension_raises
    file = Tempfile.new(["test", ".yolo"])

    assert_raises(FastWinnower::Transformations::Preprocessor::PreprocessorNotFoundError) do
      @preprocessor.call(detection_mode: :extension, data: "", path: file.path)
    end
  end

  def test_detect_by_extension_invokes_mock_preprocessor
    data = "hello"

    @preprocessor.call(detection_mode: :extension, data: data, path: @file.path) do |actual|
      assert_same data, actual[:data]
    end
  end
end
