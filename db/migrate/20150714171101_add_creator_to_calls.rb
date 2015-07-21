class AddCreatorToCalls < ActiveRecord::Migration
  def change
    add_reference :calls, :creator, index: true
    add_foreign_key :calls, :creators
  end
end
