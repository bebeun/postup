class AddAftfToAftfActions < ActiveRecord::Migration
  def change
    add_reference :aftf_actions, :aftf, index: true
    add_foreign_key :aftf_actions, :aftfs
  end
end
