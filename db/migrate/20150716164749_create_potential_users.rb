class CreatePotentialUsers < ActiveRecord::Migration
  def change
    create_table :potential_users do |t|

      t.timestamps null: false
    end
  end
end
