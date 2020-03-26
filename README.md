# Frefnet
File Reference Net (frefnet) is used to manage all the files that we store in the cloud for a client

## Usage

* Run `rake frefnet:install:migrations` and run `rake db:migrate`
* Will add a `frefnet_file_references` table to your database schema
* Will add a GET endpoint to your system that allows for you to generate a presign link for S3 uploads. You can pass these fields to a form.
* Will add a view that can be used as a basis for the S3 form upload

### Service Objects

```ruby
Frefnet::FileCreator(original_filename).run
Frefnet::DownloadLinkRetriever.new(reference_id).run
Frefnet::ContentTypeFinder.run(filename)
```

### Form Partials

This partial will setup a form POST to amazon S3, with all the required fields.

```ruby
<%= render 'frefnet_shared/s3_form_upload' do %>
  <%= file_field_tag 'file', id: 'file-upload-field', class: 'invisible', style: 'display:none;' %>
<% end %>
```

### How it works

Create a form with an upload button using the `#file-chooser` id. The form should also have a hidden field `#frefnet_id`. The idea is that when the upload to S3 is complete, this reference to the file can be placed in the hidden field and subsequently submitted to your servers.

```html
<form action="/team/courses/ec797fb8f6" accept-charset="UTF-8" data-remote="true" method="post">
  
  <div class="form-group" style="margin: 0">
    <button type="button" id="file-chooser" class="btn btn-secondary">
      <i class="fas fa-file-upload"></i>&nbsp
      Upload
    </button>
    <div class="loader" style="display: none;">
      <i class="fas fa-spinner fa-spin"></i>
    </div>
  </div>

  <div class="form-group required">
    <label class="control-label" for="course_form_description">Course Description</label>
    <textarea class="form-control" name="course_form[description]" id="course_form_description">
  dasdas</textarea>
  </div>

  <input value="" id="frefnet_id" type="hidden" name="course_form[frefnet]" />
  <input type="submit" name="commit" value="Save" class="btn btn-primary" data-disable-with="Save" />
</form>

```

Lastly, we can activate the file upload using the below.  Ensure that Frefnet is mounted in your routes file (instructions below). Notice that there are event hooks that you can use.

```
<script>
  $( document ).ready(function() {
    new FileUploader({
      useDivMode: false,
      frefnetPresignUploadPath: '<%= frefnet.file_presign_upload_path %>',
      fileUploadId: 'file-upload-field',
      acceptFileTypes: ['pdf'],
      formSubmitButtonId: 'save-file',
      onFrefCreation: function(file_reference) {
        $('#frefnet_id').val(file_reference);
        console.log("The frefnet id is " + file_reference)
      },
      onUploadSuccess: function() {
        $.ajax({
          url: '<%= root_path %>',
          type: "post",
          data: {
            fref: $('#frefnet_id').val()
          }
        })

      }
    });
  });
</script>

```

An important point to remember is not to embed the `s3_form_upload` partial inside your form - that will cause an issue. Instead always have it sitting outside your form.

The general flow is:
- Form A is the data you want to submit back to your servers, for example a form that allows you to manage user settings. This form has a hidden field, as well as a button `#file-chooser`
- Form B is generated from the Frefnet partial, this has a hidden file field tag. This form is setup to post your file to the Amazon Servers
- When `#file-chooser` is pressed, the file picker in form B is activated, and the file is selected.
  - At this point two things happen. Firstly an AJAX request is made to your Frefnet engine endpoint. This creates a file reference in the database and returns ann idea.
- Once the file uploads successfully, usually you will want to take the file referemce


## Installation
Add this line to your application's Gemfile:

```ruby
gem "frefnet", git: 'https://github.com/Webbernet/frefnet.git', branch: 'master'

```
Don't forget to add a configuration file in your host application, so Frefet knows what bucket to use

```ruby
# config/intializers/frefnet.rb
Frefnet.setup do |config|
  config.bucket = ENV['bucket']
end
```
If you want to make use of the presign upload endpoint, add this to your routes file.

```ruby
mount Frefnet::Engine => '/frefnet'
```
## Adding a reference to an existing modal

```ruby
class AddReferenceToSlide < ActiveRecord::Migration[6.0]
  def change
    add_reference :slides, :frefnet_file_reference, type: :uuid
  end
end
```

or with a custom name

```ruby
class AddReferenceToSlide < ActiveRecord::Migration[6.0]
  def change
    add_reference :courses, :thumbnail_frefnet, foreign_key: { to_table: :frefnet_file_references }, type: :uuid
  end
end
