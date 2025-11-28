require 'singleton'
require_relative '../model/bukket_adapter/google_bukket_adapter'

class BucketAdapterFactory
  include Singleton

  def get_adapter(adapter_type)
    case adapter_type
    when :google
      if @google_adapter
        return @google_adapter
      end
      @google_adapter ||= GoogleBukketAdapter.new
    else
      raise UnknownAdapterTypeError, "Unknown adapter type: #{adapter_type}"
    end
  end
end