module Frefnet
  # Creates the file in the system so it can actually be tracked,
  # and is able to determine the content-type from the file name.
  class FileCreator
    def initialize(original_filename:, key_start_override: nil)
      @original_filename = original_filename
      @key_start = key_start_override || 'file_storage/'
    end

    def run
      Frefnet::FileReference.create(
        key: "#{@key_start}#{SecureRandom.uuid}",
        content_type: ContentTypeFinder.run(@original_filename),
        original_filename: @original_filename
      )
    end
  end
end
