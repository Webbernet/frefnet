# Because of the nature of the Frefnet requests, it's critical
# that we have a way to detect if a file has successfully uploaded
# to S3. This is a validator that can be used in any forms that
# support ActiveModel validators can be called with
#
# validates_with Frefnet::FileExistsValidator
#
# This helper looks at all form keys with that have 'frefnet'
# in the string and validates those.
module Frefnet
  class FileExistsValidator < ActiveModel::Validator

    def validate(form)
      @form = form
      return if all_keys_exist
      @form.errors.add(:base, 'File upload Failed, please try uploading again.')
    end

    private

    def all_keys_exist
      frefnet_keys.all? do |key|
        obj = bucket.object(key)
        obj.exists?
      end
    end

    def bucket
      Aws::S3::Bucket.new(Frefnet.config.bucket)
    end

    def frefnet_ids_to_check
      @form.attributes.map do |key, value|
        next unless key.to_s.include?('frefnet') || key.to_s.include?('file_reference')
        value
      end
    end

    def frefnet_keys
      Frefnet::FileReference.where(id: frefnet_ids_to_check).map(&:key)
    end
  end
end
