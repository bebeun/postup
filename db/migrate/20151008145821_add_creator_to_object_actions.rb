class AddCreatorToObjectActions < ActiveRecord::Migration
  def change
    add_reference :object_actions, :creator, index: true
    add_foreign_key :object_actions, :creators
  end
end
