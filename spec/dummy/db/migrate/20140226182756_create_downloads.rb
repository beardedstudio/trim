class CreateDownloads < ActiveRecord::Migration
  def change

    create_table "trim_downloads", :force => true do |t|
      t.integer  "downloadable_id",                       :null => false
      t.string   "downloadable_type",                     :null => false

      t.text     "caption",               :default => "", :null => false
      t.string   "title",                 :default => "", :null => false
      t.integer  "sort",                  :default => 0,  :null => false

      t.string   "download_file_name"
      t.integer  "download_file_size"
      t.string   "download_content_type"
      t.datetime "download_updated_at"
      
      t.timestamps
    end

    add_index "trim_downloads", ["downloadable_id", "downloadable_type"]

  end
end
