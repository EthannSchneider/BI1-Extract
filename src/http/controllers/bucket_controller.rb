require_relative '../config'
require_relative '../../../src/service/bucket_service'
require_relative 'fake_bucket_sdk'

get PREFIX + 'objects' do
  content_type :json

  bucket_service = BucketService.new

  bucket_service.list("").to_json
end
