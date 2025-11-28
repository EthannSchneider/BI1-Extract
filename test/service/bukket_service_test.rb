require 'minitest/autorun'
require 'minitest/mock'
require_relative '../../src/service/bucket_service'

class BukketServiceTest < Minitest::Test
  def setup
    ENV.delete('BUCKET_ADAPTER')
    @adapter = Minitest::Mock.new
    factory = Minitest::Mock.new
    factory.expect :get_adapter, @adapter, [nil]
    BucketAdapterFactory.stub :instance, factory do
      @service = BucketService.new
    end
  end

  def teardown
    ENV.delete('BUCKET_ADAPTER')
    begin
      current = BucketAdapterFactory.method(:instance).call
      if current.is_a?(Minitest::Mock)
        BucketAdapterFactory.singleton_class.send(:remove_method, :instance)
      end
    rescue NameError, NoMethodError
    end
  end

  def test_upload_delegates_to_adapter
    @adapter.expect :upload, true, ['local/path', 'remote/path']
    assert_equal true, @service.upload('local/path', 'remote/path')
    @adapter.verify
  end

  def test_download_delegates_to_adapter
    @adapter.expect :download, true, ['remote/path', 'local/path']
    assert_equal true, @service.download('remote/path', 'local/path')
    @adapter.verify
  end

  def test_delete_delegates_to_adapter_with_default_recursive
    @adapter.expect :delete, true, ['remote/path', false]
    assert_equal true, @service.delete('remote/path')
    @adapter.verify
  end

  def test_delete_delegates_to_adapter_with_recursive_true
    @adapter.expect :delete, true, ['remote/path', true]
    assert_equal true, @service.delete('remote/path', true)
    @adapter.verify
  end

  def test_list_delegates_to_adapter
    expected = ['a', 'b']
    @adapter.expect :list, expected, ['remote/path']
    assert_equal expected, @service.list('remote/path')
    @adapter.verify
  end
end