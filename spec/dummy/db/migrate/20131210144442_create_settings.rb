class CreateSettings < ActiveRecord::Migration
  def change
    create_table "trim_settings", :force => true do |t|
      t.text     "settings"
      t.datetime "updated_at", :null => false
    end
  end
end
