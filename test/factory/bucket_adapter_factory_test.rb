require 'minitest/autorun'
require 'minitest/mock'
require_relative '../../src/factory/bucket_adapter_factory'

class BucketAdapterFactoryTest < Minitest::Test
  def test_get_google_adapter_returns_mock_instance
    factory = BucketAdapterFactory.instance
    factory.instance_variable_set(:@google_adapter, nil)

    mock_adapter = Object.new

    GoogleBukketAdapter.stub :new, mock_adapter do
      adapter = factory.get_adapter(:google)
      assert_same mock_adapter, adapter 
    end
  end

  def test_get_adapter_unknown_raises
    err = assert_raises(RuntimeError) { BucketAdapterFactory.instance.get_adapter(:aws) }
    assert_equal "Unknown adapter type: aws", err.message
  end

  def test_singleton_instance_same
    a = BucketAdapterFactory.instance
    b = BucketAdapterFactory.instance
    assert_same a, b
  end
end