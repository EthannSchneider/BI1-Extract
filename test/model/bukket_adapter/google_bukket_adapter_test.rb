require 'minitest/autorun'
require 'minitest/mock'
require_relative '../../../src/model/bukket_adapter/google_bukket_adapter'

class GoogleBukketAdapterTest < Minitest::Test
  def setup_env
    ENV['GOOGLE_CLOUD_SERVICE_ACCOUNT_JSON'] = '{}'
    ENV['GOOGLE_CLOUD_PROJECT_ID'] = 'test-project'
    ENV['GOOGLE_CLOUD_BUCKET_NAME'] = 'test-bucket'
    ENV['GOOGLE_CLOUD_SCOPE'] = 'scope'
  end

  def teardown
    ENV.delete('GOOGLE_CLOUD_SERVICE_ACCOUNT_JSON')
    ENV.delete('GOOGLE_CLOUD_PROJECT_ID')
    ENV.delete('GOOGLE_CLOUD_BUCKET_NAME')
    ENV.delete('GOOGLE_CLOUD_SCOPE')
  end

  def build_adapter_with_mocks(storage_mock, bucket_mock)
    setup_env
    storage_mock.expect :bucket, bucket_mock, [ENV['GOOGLE_CLOUD_BUCKET_NAME']]
    ::Google::Auth::ServiceAccountCredentials.stub :make_creds, :creds do
      ::Google::Cloud::Storage.stub :new, storage_mock do
        return GoogleBukketAdapter.new
      end
    end
  end

  def test_upload_calls_create_file_on_bucket
    storage = Minitest::Mock.new
    bucket = Minitest::Mock.new
    bucket.expect :create_file, nil, ['local.txt', 'dest.txt']

    adapter = build_adapter_with_mocks(storage, bucket)
    adapter.upload('local.txt', 'dest.txt')

    bucket.verify
    storage.verify
  end

  def test_download_calls_download_if_file_exists
    storage = Minitest::Mock.new
    bucket = Minitest::Mock.new
    file = Minitest::Mock.new

    bucket.expect :file, file, ['remote/path']
    file.expect :download, nil, ['local/path']

    adapter = build_adapter_with_mocks(storage, bucket)
    adapter.download('remote/path', 'local/path')

    file.verify
    bucket.verify
    storage.verify
  end

  def test_download_does_nothing_if_file_missing
    storage = Minitest::Mock.new
    bucket = Minitest::Mock.new

    bucket.expect :file, nil, ['missing/path']

    adapter = build_adapter_with_mocks(storage, bucket)
    # Should not raise
    adapter.download('missing/path', 'local/path')

    bucket.verify
    storage.verify
  end

  def test_delete_non_recursive_deletes_file_when_present
    storage = Minitest::Mock.new
    bucket = Minitest::Mock.new
    file = Minitest::Mock.new

    bucket.expect :file, file, ['to/delete']
    file.expect :delete, nil

    adapter = build_adapter_with_mocks(storage, bucket)
    adapter.delete('to/delete', false)

    file.verify
    bucket.verify
    storage.verify
  end

  def test_delete_non_recursive_noop_when_file_missing
    storage = Minitest::Mock.new
    bucket = Minitest::Mock.new

    bucket.expect :file, nil, ['nope']

    adapter = build_adapter_with_mocks(storage, bucket)
    adapter.delete('nope', false)

    bucket.verify
    storage.verify
  end

  def test_delete_recursive_deletes_all_files_with_prefix
    storage = Minitest::Mock.new
    bucket = Minitest::Mock.new
    f1 = Minitest::Mock.new
    f2 = Minitest::Mock.new

    bucket.expect :files, [f1, f2], [], prefix: 'dir/'
    f1.expect :delete, nil
    f2.expect :delete, nil

    adapter = build_adapter_with_mocks(storage, bucket)
    adapter.delete('dir/', true)

    f1.verify
    f2.verify
    bucket.verify
    storage.verify
  end

  def test_list_returns_names_of_files_with_prefix
    storage = Minitest::Mock.new
    bucket = Minitest::Mock.new
    f1 = Minitest::Mock.new
    f2 = Minitest::Mock.new
    f1.expect :name, 'dir/a.txt'
    f2.expect :name, 'dir/b.txt'
    bucket.expect :files, [f1, f2], [], prefix: 'dir/'

    adapter = build_adapter_with_mocks(storage, bucket)
    result = adapter.list('dir/')

    assert_equal ['dir/a.txt', 'dir/b.txt'], result

    bucket.verify
    storage.verify
    f1.verify
    f2.verify
  end
end
