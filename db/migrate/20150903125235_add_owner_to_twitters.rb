class AddOwnerToTwitters < ActiveRecord::Migration
  def change
    add_reference :twitters, :owner, polymorphic: true, index: true
  end
end
