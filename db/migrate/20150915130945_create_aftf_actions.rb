class CreateAftfActions < ActiveRecord::Migration
  def change
    create_table :aftf_actions do |t|

      t.timestamps null: false
    end
  end
end
