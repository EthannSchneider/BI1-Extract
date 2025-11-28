class BucketFile
  def initialize(name)
    @name = name
  end

  def name
    @name
  end

  def download(local_src)
  end

  def delete
  end
end

class Bucket
  def create_file(local_src, remote_src)
  end

  def file(remote_src)
    BucketFile.new(remote_src)
  end

  def files(remote_src)
    [BucketFile.new("file1.txt"), BucketFile.new("file2.txt")]
  end
end

class GoogleBukketAdapter
  def initialize
    @bucket = Bucket.new
  end
end

