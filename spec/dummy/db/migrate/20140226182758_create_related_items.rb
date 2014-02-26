class CreateRelatedItems < ActiveRecord::Migration
  def change

    create_table "trim_related_items", :force => true do |t|
      t.integer  "related_from_id",                  :null => false
      t.string   "related_from_type",                :null => false

      t.integer  "related_to_id",                    :null => false
      t.string   "related_to_type",                  :null => false

      t.integer  "sort",              :default => 0, :null => false
      
      t.timestamps
    end

    add_index "trim_related_items", ["related_from_id", "related_from_type"], :name => 'index_trim_related_items_from'
    add_index "trim_related_items", ["related_to_id", "related_to_type"], :name => 'index_trim_related_items_to'

  end
end
