# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20131211193103) do

  create_table "friendly_id_slugs", :force => true do |t|
    t.string   "slug",                         :null => false
    t.integer  "sluggable_id",                 :null => false
    t.string   "sluggable_type", :limit => 40
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type"], :name => "index_friendly_id_slugs_on_slug_and_sluggable_type", :unique => true
  add_index "friendly_id_slugs", ["sluggable_id"], :name => "index_friendly_id_slugs_on_sluggable_id"
  add_index "friendly_id_slugs", ["sluggable_type"], :name => "index_friendly_id_slugs_on_sluggable_type"

  create_table "rails_admin_histories", :force => true do |t|
    t.text     "message"
    t.string   "username"
    t.integer  "item"
    t.string   "table"
    t.integer  "month",      :limit => 2
    t.integer  "year",       :limit => 5
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  add_index "rails_admin_histories", ["item", "table", "month", "year"], :name => "index_rails_admin_histories"

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
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
  end

  add_index "trim_downloads", ["downloadable_id", "downloadable_type"], :name => "index_trim_downloads_on_downloadable_id_and_downloadable_type"

  create_table "trim_images", :force => true do |t|
    t.integer  "imageable_id",                       :null => false
    t.string   "imageable_type",                     :null => false
    t.text     "caption",            :default => "", :null => false
    t.string   "alt_text",           :default => "", :null => false
    t.integer  "sort",               :default => 0,  :null => false
    t.string   "image_file_name",                    :null => false
    t.integer  "image_file_size",                    :null => false
    t.string   "image_content_type"
    t.datetime "image_updated_at"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  add_index "trim_images", ["imageable_id", "imageable_type"], :name => "index_trim_images_on_imageable_id_and_imageable_type"

  create_table "trim_lead_images", :force => true do |t|
    t.integer  "imageable_id",                       :null => false
    t.string   "imageable_type",                     :null => false
    t.string   "alt_text",           :default => "", :null => false
    t.string   "image_file_name",                    :null => false
    t.integer  "image_file_size",                    :null => false
    t.string   "image_content_type"
    t.datetime "image_updated_at"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  add_index "trim_lead_images", ["imageable_id", "imageable_type"], :name => "index_trim_lead_images_on_imageable_id_and_imageable_type"

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

  create_table "trim_pages", :force => true do |t|
    t.string   "title",       :default => "",    :null => false
    t.text     "body"
    t.text     "teaser"
    t.text     "excerpt"
    t.string   "slug",        :default => "",    :null => false
    t.string   "custom_slug"
    t.boolean  "is_private",  :default => false, :null => false
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  add_index "trim_pages", ["slug"], :name => "index_pages_on_slug"

  create_table "trim_related_items", :force => true do |t|
    t.integer  "related_from_id",                  :null => false
    t.string   "related_from_type",                :null => false
    t.integer  "related_to_id",                    :null => false
    t.string   "related_to_type",                  :null => false
    t.integer  "sort",              :default => 0, :null => false
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  add_index "trim_related_items", ["related_from_id", "related_from_type"], :name => "index_trim_related_items_from"
  add_index "trim_related_items", ["related_to_id", "related_to_type"], :name => "index_trim_related_items_to"

  create_table "trim_settings", :force => true do |t|
    t.text     "settings"
    t.datetime "updated_at", :null => false
  end

  create_table "trim_videos", :force => true do |t|
    t.string   "video_url",                      :null => false
    t.text     "caption"
    t.integer  "sort",            :default => 0, :null => false
    t.integer  "embeddable_id",                  :null => false
    t.string   "embeddable_type",                :null => false
    t.integer  "provider",        :default => 0, :null => false
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  add_index "trim_videos", ["embeddable_id", "embeddable_type"], :name => "index_trim_videos_on_embeddable_id_and_embeddable_type"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0,  :null => false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "name"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
