class CreateFrefnetFileReferences < ActiveRecord::Migration[5.2]
  def change
    create_table :frefnet_file_references, id: :uuid do |t|
      t.string :key, null: false, index: { unique: true }
      t.string :content_type, null: false
      t.hstore :meta_data
      t.integer :size
      t.timestamps
    end
  end
end
