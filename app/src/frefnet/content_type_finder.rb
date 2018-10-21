require 'mime/types'

module Frefnet
  class ContentTypeFinder
    def self.run(filename)
      extension = File.extname(filename)
      MIME::Types.type_for(extension).first.to_s
    end
  end
end
