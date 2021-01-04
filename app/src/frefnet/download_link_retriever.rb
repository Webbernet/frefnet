# Allows the caller to pass a user and have a short-lived
# URL that can be used to access the file.
module Frefnet
  class DownloadLinkRetriever
    def initialize(reference_id_or_model)
      @reference_id_or_model = reference_id_or_model
    end

    def run
      key = file.key
      presign(key)
    end

    private

    def presign(key)
      S3_PRESIGNER.presigned_url(
        :get_object,
        bucket: Frefnet.config.bucket,
        key: key,
        response_content_disposition: content_disposition
      )
    end

    def file
      return @reference_id_or_model if @reference_id_or_model.is_a?(Frefnet::FileReference)

      @file ||= Frefnet::FileReference.find(@reference_id_or_model)
    end

    def content_disposition
      "attachment; filename=\"#{file.original_filename}\""
    end
  end
end
