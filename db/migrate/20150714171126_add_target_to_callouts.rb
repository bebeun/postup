class AddTargetToCallouts < ActiveRecord::Migration
  def change
    add_reference :callouts, :target, index: true
    add_foreign_key :callouts, :targets
  end
end
