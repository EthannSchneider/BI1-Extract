require_relative '../factory/bucket_adapter_factory'

class BucketService
  def initialize
    bucket_factory = BucketAdapterFactory.new
    @bucket_adapter = bucket_factory.get_adapter(ENV['BUCKET_ADAPTER']&.to_sym)
  end

  def upload(local_src, remote_src)
    @bucket_adapter.upload(local_src, remote_src)
  end

  def download(remote_src, local_src)
    @bucket_adapter.download(remote_src, local_src)
  end

  def delete(remote_src, recursive = false)
    @bucket_adapter.delete(remote_src, recursive)
  end

  def list(remote_src)
    @bucket_adapter.list(remote_src)
  end
end