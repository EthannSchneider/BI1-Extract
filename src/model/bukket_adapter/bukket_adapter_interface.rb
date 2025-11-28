class BukketAdapterInterface
  def upload(local_src, remote_src)
    raise NotImplementedError.new("This #{self.class} cannot respond to:")
  end

  def download(remote_src, local_src)
    raise NotImplementedError.new("This #{self.class} cannot respond to:")
  end

  def delete(remote_src, recursive=false)
    raise NotImplementedError.new("This #{self.class} cannot respond to:")
  end

  def list(remote_src)
    raise NotImplementedError.new("This #{self.class} cannot respond to:")
  end
end