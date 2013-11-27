class CreatePages < ActiveRecord::Migration
  def change

    create_table "trim_pages", :force => true do |t|
      t.string   "title",       :default => "",    :null => false
      t.text     "body"
      t.text     "teaser"
      t.text     "excerpt"
      t.string   "slug",        :default => "",    :null => false
      t.string   "custom_slug"
      t.boolean  "is_private",  :default => false, :null => false

      t.timestamps
    end

    add_index "trim_pages", ["slug"], :name => "index_pages_on_slug"

  end
end
