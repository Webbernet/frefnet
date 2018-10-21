class AddOriginalFilenameToFileReferences < ActiveRecord::Migration[5.2]
  def change
    add_column :frefnet_file_references, :original_filename, :string
  end
end
