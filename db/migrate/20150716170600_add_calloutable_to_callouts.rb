class AddCalloutableToCallouts < ActiveRecord::Migration
  def change
    add_reference :callouts, :calloutable, polymorphic: true, index: true
    add_foreign_key :callouts, :calloutables
  end
end
