class CreateObjectActions < ActiveRecord::Migration
  def change
    create_table :object_actions do |t|
      t.references :object, polymorphic: true, index: true
      t.string :support

      t.timestamps null: false
    end
  end
end
