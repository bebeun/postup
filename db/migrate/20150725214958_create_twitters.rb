class CreateTwitters < ActiveRecord::Migration
  def change
    create_table :twitters do |t|
      t.string :description

      t.timestamps null: false
    end
  end
end
