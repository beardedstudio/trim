class CreateNavs < ActiveRecord::Migration
  def change

    create_table :trim_nav_items do |t|
      t.string     :title,              :null => false
      t.string     :slug
      t.string     :custom_slug
      t.string     :nav_path,           :null => false
      t.integer    :nav_item_type,      :default => 0,     :null => false
      t.references :linked,             :polymorphic => true
      t.string     :route
      t.string     :custom_url
      t.boolean    :open_in_new_window, :default => false
      t.string     :ancestry
      t.integer    :ancestry_depth,     :default => 0
      t.integer    :sort
      t.integer    :nav_id

      t.timestamps
    end

    add_index :trim_nav_items, :ancestry
    add_index :trim_nav_items, [:linked_id, :linked_type]
    add_index :trim_nav_items, :slug


    create_table :trim_navs do |t|
      t.string  :title,             :null => false
      t.string  :slug,              :null => false
      t.integer :nav_item_id,  :null => false
      t.integer :priority,          :default => 1,  :null => false

      t.timestamps
    end

    add_index :trim_navs, :slug
    add_index :trim_navs, :nav_item_id
    add_index :trim_navs, :priority

  end
end
