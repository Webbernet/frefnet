# Allows the caller to pass a user and have a short-lived
# URL that can be used to access the file.
module Frefnet
  class DownloadLinkRetriever
    def initialize(reference_id)
      @reference_id = reference_id
    end

    def run
      key = file.key
      presign(key)
    end

    private

    def presign(key)
      s3 = Aws::S3::Presigner.new
      s3.presigned_url(
        :get_object,
        bucket: Frefnet.config.bucket,
        key: key,
        response_content_disposition: content_disposition
      )
    end

    def file
      @file ||= Frefnet::FileReference.find(@reference_id)
    end

    def content_disposition
      "attachment; filename=\"#{file.original_filename}\""
    end
  end
end
