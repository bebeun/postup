class CreateCalloutsUsers < ActiveRecord::Migration
  def change
    create_table :callouts_users do |t|

      t.timestamps null: false
    end
  end
end
