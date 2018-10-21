# Creates the file in the system so it can actually be tracked
module Frefnet
  class FileCreator
    def initialize(original_filename:)
      @original_filename = original_filename
    end

    def run
      Frefnet::FileReference.create(
        key: SecureRandom.hex,
        content_type: ContentTypeFinder.run(@original_filename),
        original_filename: @original_filename
      )
    end
  end
end
