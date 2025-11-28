require_relative '../config'
require_relative '../../../src/service/bucket_service'
require_relative '../../exceptions/missing_google_cloud_credentials_error'

get PREFIX + 'objects' do
  content_type :json

  bucket_service = BucketService.new

  bucket_service.list("").to_json
rescue StandardError => e
  status 500
  { error: e.message }.to_json
end
