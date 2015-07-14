class AddCreatorToCallouts < ActiveRecord::Migration
  def change
    add_reference :callouts, :creator, index: true
    add_foreign_key :callouts, :creators
  end
end
