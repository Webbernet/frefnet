module Frefnet
  class FileController < ApplicationController
    skip_before_action :verify_authenticity_token, only: [:presign_upload]

    def presign_upload
      @facade = PresignUploadFacade.new(params)
      render json: @facade.run
    end

    def add_row; end

    def delete_row; end
  end
end
