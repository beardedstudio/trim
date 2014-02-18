class CreateVideos < ActiveRecord::Migration
  def change
    create_table :trim_videos do |t|
      t.string   "video_url",                          :null => false
      t.text     "caption"
      t.integer  "sort",               :default => 0,  :null => false
      t.integer  "embeddable_id",                     :null => false
      t.string   "embeddable_type",                   :null => false
      t.integer  'provider',           :default => Trim::Video::YOUTUBE, :null => false
      t.timestamps
    end

    add_index :trim_videos, [:embeddable_id, :embeddable_type]
  end
end
