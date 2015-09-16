class CreateAftfs < ActiveRecord::Migration
  def change
    create_table :aftfs do |t|
      t.references :creator, index: true
      t.references :conversation, index: true

      t.timestamps null: false
    end
    add_foreign_key :aftfs, :creators
    add_foreign_key :aftfs, :conversations
  end
end
