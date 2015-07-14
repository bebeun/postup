class CreateCallouts < ActiveRecord::Migration
  def change
    create_table :callouts do |t|

      t.timestamps null: false
    end
  end
end
