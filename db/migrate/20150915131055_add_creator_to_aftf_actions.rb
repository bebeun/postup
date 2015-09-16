class AddCreatorToAftfActions < ActiveRecord::Migration
  def change
    add_reference :aftf_actions, :creator, index: true
    add_foreign_key :aftf_actions, :creators
  end
end
