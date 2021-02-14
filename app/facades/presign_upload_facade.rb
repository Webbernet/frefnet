# This endpoint allows us to setup a presigned upload
# so that we can upload files directly from the browser
# bypassing the server.

# This endpoint is usually hit after a user selects a file
# in their browser to upload. We return all the upload
# fields that should be appended to the S3 upload form
# (as hidden fiends) as well as the name of the file,
# and the Frefnet File Reference.

# The Frefnet File Reference is especially important as that
# is how the host application can bind it to a record!
class PresignUploadFacade
  def initialize(params)
    @params = params
  end

  def run
    {
      upload_fields: presigned_post_fields,
      file_ref_id: frefnet_file.id,
      file_name: file_name
    }
  end

  private

  def presigned_post_fields
    bucket.presigned_post(
      {
        key: frefnet_file.key,
        acl: 'private',
        success_action_status: '200',
        content_type: frefnet_file.content_type,
        metadata: {
          original_filename: file_name,
          fref_id: frefnet_file.id
        }
      }
    ).fields
  end

  def frefnet_file
    @frefnet_file ||= Frefnet::FileCreator.new(
      original_filename: file_name,
      key_start_override: @params[:key_start_override]
    ).run
  end

  def bucket
    Aws::S3::Bucket.new(Frefnet.config.bucket)
  end

  def file_name
    @params[:file_name]
  end
end
