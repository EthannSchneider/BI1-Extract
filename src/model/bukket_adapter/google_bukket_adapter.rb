require "googleauth"
require "google/cloud/storage"
require_relative "bukket_adapter_interface"
require 'dotenv/load'
require_relative '../../exceptions/missing_google_cloud_credentials_error'

class GoogleBukketAdapter < BukketAdapterInterface
  def initialize
    if ENV['GOOGLE_CLOUD_SERVICE_ACCOUNT_JSON'].nil? || ENV['GOOGLE_CLOUD_PROJECT_ID'].nil? || ENV['GOOGLE_CLOUD_BUCKET_NAME'].nil?
      raise MissingGoogleCloudCredentialsError, "Google Cloud credentials are not properly set in environment variables."
    end

    credentials = ::Google::Auth::ServiceAccountCredentials.make_creds(
      json_key_io: StringIO.new(ENV['GOOGLE_CLOUD_SERVICE_ACCOUNT_JSON']),
      scope: ENV['GOOGLE_CLOUD_SCOPE'] || 'https://www.googleapis.com/auth/cloud-platform'
    )

    @storage = Google::Cloud::Storage.new(
      project_id: ENV['GOOGLE_CLOUD_PROJECT_ID'],
      credentials: credentials
    )
    @bucket = @storage.bucket(ENV['GOOGLE_CLOUD_BUCKET_NAME'])
  end

  def upload(local_src, remote_src)
    @bucket.create_file(local_src, remote_src)
  end

  def download(remote_src, local_src)
    file = @bucket.file(remote_src)
    file.download(local_src) if file
  end

  def delete(remote_src, recursive=false)
    if recursive
      files = @bucket.files(prefix: remote_src)
      files.each(&:delete)
    else
      file = @bucket.file(remote_src)
      file.delete if file
    end
  end

  def list(remote_src)
    files = @bucket.files(prefix: remote_src)
    files.map(&:name)
  end
end