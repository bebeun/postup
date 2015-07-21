class CreateCallActions < ActiveRecord::Migration
  def change
    create_table :call_actions do |t|
	  t.belongs_to :user, index: true
      t.belongs_to :call, index: true
      t.timestamps null: false
    end
  end
end
