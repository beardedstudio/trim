class CreateLeadImages < ActiveRecord::Migration
  def change

    create_table "trim_lead_images", :force => true do |t|
      t.integer  "imageable_id",                       :null => false
      t.string   "imageable_type",                     :null => false
      t.string   "caption"
      t.string   "alt_text",           :default => "", :null => false

      t.string   "image_file_name",                    :null => false
      t.integer  "image_file_size",                    :null => false
      t.string   "image_content_type"
      t.datetime "image_updated_at"

      t.timestamps
    end

    add_index "trim_lead_images", ["imageable_id", "imageable_type"]

  end
end
