module Frefnet
  # Creates the file in the system so it can actually be tracked,
  # and is able to determine the content-type from the file name.
  class FileCreator
    def initialize(original_filename:)
      @original_filename = original_filename
    end

    def run
      Frefnet::FileReference.create(
        key: "file_storage/#{SecureRandom.uuid}",
        content_type: ContentTypeFinder.run(@original_filename),
        original_filename: @original_filename
      )
    end
  end
end
