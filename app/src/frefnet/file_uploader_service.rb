require 'open-uri'
module Frefnet
  class FileUploaderService
    attr_reader :key

    def initialize(key)
      @key = key
    end

    def upload_stream(stream)
      s3 = Aws::S3::Client.new
      s3.put_object(bucket: Frefnet.config.bucket, key: key, body: stream)
    end

    def upload_file(path, metadata = {})
      File.open(path) do |file|
        resource_obj.put(body: file, metadata: metadata)
      end
    end

    def remote_upload_stream(url)
      open(url) do |file|
        resource_obj.put(body: file)
      end
    end

    private

    def s3_resource
      Aws::S3::Resource.new
    end

    def resource_obj
      s3_resource.bucket(Frefnet.config.bucket).object(key)
    end
  end
end
