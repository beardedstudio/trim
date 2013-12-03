class CreateNavs < ActiveRecord::Migration
  def change

    create_table "trim_nav_items", :force => true do |t|
      t.string   "title",               :default => "",    :null => false
      t.text     "description",         :default => "",    :null => false
      t.integer  "master_item"
      t.string   "path",                :default => "",    :null => false
      t.string   "route",               :default => "",    :null => false
      t.string   "route_params",        :default => "",    :null => false
      t.integer  "parent_id"
      t.integer  "lft"
      t.integer  "rgt"
      t.integer  "linked_id"
      t.string   "linked_type"
      t.string   "slug"
      t.string   "custom_slug",         :default => "",    :null => false
      t.boolean  "use_linked_in_route", :default => false, :null => false
      t.datetime "created_at",                             :null => false
      t.datetime "updated_at",                             :null => false
      t.string   "custom_url"
      t.boolean  "open_in_new_window",  :default => false
    end

    add_index "trim_nav_items", ["lft"], :name => "index_nav_items_on_lft"
    add_index "trim_nav_items", ["linked_id", "linked_type"], :name => "index_nav_items_on_linked_id_and_linked_type"
    add_index "trim_nav_items", ["parent_id"], :name => "index_nav_items_on_parent_id"
    add_index "trim_nav_items", ["rgt"], :name => "index_nav_items_on_rgt"
    add_index "trim_nav_items", ["slug"], :name => "index_nav_items_on_slug"

    create_table "trim_navs", :force => true do |t|
      t.string   "title",       :default => "",    :null => false
      t.string   "slug"
      t.integer  "nav_item_id"
      t.integer  "depth_start", :default => 0,     :null => false
      t.integer  "depth_end"
      t.integer  "item_start"
      t.integer  "item_end"
      t.boolean  "use_as_root", :default => false, :null => false
      t.datetime "created_at",                     :null => false
      t.datetime "updated_at",                     :null => false
    end

    add_index "trim_navs", ["slug"], :name => "index_navs_on_slug", :unique => true

  end
end
