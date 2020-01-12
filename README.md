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

```ruby
<%= render 'frefnet_shared/s3_form_upload' do %>
  <%= file_field_tag 'file', class: 'invisible', style: 'display:none;' %>
<% end %>
```

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
